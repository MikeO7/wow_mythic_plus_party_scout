-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2026 Bernhard Saumweber
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L

function PGF.HandleSyntaxError(error)
    error = tostring(error)
    error = string.gsub(error, "^.-:%d+:%s*", "")
    PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.syntax"], error))
end

function PGF.HandleSemanticError(error)
    error = tostring(error)
    error = string.gsub(error, "^.-:%d+:%s*", "")
    if error:find("name") or error:find("comment") then
        PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.semantic.protected"], error))
    else
        PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.semantic"], error))
    end
end

-- Cache the last compiled expression to avoid redundant parsing
local lastExpressionString = nil
local lastCompiledTree = nil

-- Simple Lua-like expression evaluator
local function Evaluate(node, env, depth)
    if type(node) ~= "table" then return node end

    depth = depth or 0
    if depth > 50 then error("expression too complex to evaluate") end

    local op = node.op
    if op == "id" then
        local val = env[node.value]
        if type(val) == "function" then
            return function(...) return val(...) end
        end
        return val
    elseif op == "const" then
        return node.value
    elseif op == "call" then
        local fn = Evaluate(node.fn, env, depth + 1)
        if type(fn) == "function" then
            local args = {}
            for i, argNode in ipairs(node.args) do
                args[i] = Evaluate(argNode, env, depth + 1)
            end
            return fn(unpack(args))
        end
        error("attempt to call a non-function value")
    elseif op == "not" then
        return not Evaluate(node.operand, env, depth + 1)
    elseif op == "and" then
        return Evaluate(node.left, env, depth + 1) and Evaluate(node.right, env, depth + 1)
    elseif op == "or" then
        return Evaluate(node.left, env, depth + 1) or Evaluate(node.right, env, depth + 1)
    elseif op == "==" then
        return Evaluate(node.left, env, depth + 1) == Evaluate(node.right, env, depth + 1)
    elseif op == "~=" then
        return Evaluate(node.left, env, depth + 1) ~= Evaluate(node.right, env, depth + 1)
    elseif op == "<" then
        return Evaluate(node.left, env, depth + 1) < Evaluate(node.right, env, depth + 1)
    elseif op == ">" then
        return Evaluate(node.left, env, depth + 1) > Evaluate(node.right, env, depth + 1)
    elseif op == "<=" then
        return Evaluate(node.left, env, depth + 1) <= Evaluate(node.right, env, depth + 1)
    elseif op == ">=" then
        return Evaluate(node.left, env, depth + 1) >= Evaluate(node.right, env, depth + 1)
    end
end

local function Tokenize(exp)
    local tokens = {}
    local pos = 1
    while pos <= #exp do
        local c = exp:sub(pos, pos)
        if c:match("%s") then
            pos = pos + 1
        elseif exp:sub(pos, pos+1) == "==" then
            table.insert(tokens, { type = "op", value = "==" })
            pos = pos + 2
        elseif exp:sub(pos, pos+1) == "~=" then
            table.insert(tokens, { type = "op", value = "~=" })
            pos = pos + 2
        elseif exp:sub(pos, pos+1) == "<=" then
            table.insert(tokens, { type = "op", value = "<=" })
            pos = pos + 2
        elseif exp:sub(pos, pos+1) == ">=" then
            table.insert(tokens, { type = "op", value = ">=" })
            pos = pos + 2
        elseif c == "<" or c == ">" or c == "(" or c == ")" or c == "," then
            table.insert(tokens, { type = "op", value = c })
            pos = pos + 1
        elseif c == "\"" or c == "'" then
            local quote = c
            local start = pos + 1
            pos = pos + 1
            while pos <= #exp and exp:sub(pos, pos) ~= quote do
                pos = pos + 1
            end
            table.insert(tokens, { type = "const", value = exp:sub(start, pos - 1) })
            pos = pos + 1
        elseif c:match("[%d%.]") then
            local start = pos
            while pos <= #exp and exp:sub(pos, pos):match("[%d%.]") do
                pos = pos + 1
            end
            table.insert(tokens, { type = "const", value = tonumber(exp:sub(start, pos - 1)) })
        elseif c:match("[%a_]") then
            local start = pos
            while pos <= #exp and exp:sub(pos, pos):match("[%w_]") do
                pos = pos + 1
            end
            local word = exp:sub(start, pos - 1)
            if word == "and" or word == "or" or word == "not" then
                table.insert(tokens, { type = "op", value = word })
            elseif word == "true" then
                table.insert(tokens, { type = "const", value = true })
            elseif word == "false" then
                table.insert(tokens, { type = "const", value = false })
            elseif word == "nil" then
                table.insert(tokens, { type = "const", value = nil })
            else
                table.insert(tokens, { type = "id", value = word })
            end
        else
            error("unexpected character: " .. c)
        end
    end
    return tokens
end

local function Parse(tokens)
    local pos = 1

    local function Peek() return tokens[pos] end
    local function Consume() local t = tokens[pos]; pos = pos + 1; return t end

    local ParseExpr -- forward decl

    local function ParsePrimary(depth)
        depth = depth or 0
        if depth > 50 then error("expression too complex") end

        local t = Consume()
        if not t then error("unexpected end of expression") end
        if t.type == "const" then
            return { op = "const", value = t.value }
        elseif t.type == "id" then
            local node = { op = "id", value = t.value }
            if Peek() and Peek().value == "(" then
                Consume() -- (
                local args = {}
                if Peek() and Peek().value ~= ")" then
                    table.insert(args, ParseExpr(depth + 1))
                    while Peek() and Peek().value == "," do
                        Consume() -- ,
                        table.insert(args, ParseExpr(depth + 1))
                    end
                end
                if not Peek() or Peek().value ~= ")" then error("missing closing parenthesis") end
                Consume() -- )
                return { op = "call", fn = node, args = args }
            end
            return node
        elseif t.value == "(" then
            local node = ParseExpr(depth + 1)
            if not Peek() or Peek().value ~= ")" then error("missing closing parenthesis") end
            Consume() -- )
            return node
        elseif t.value == "not" then
            return { op = "not", operand = ParsePrimary(depth + 1) }
        else
            error("unexpected token: " .. tostring(t.value))
        end
    end

    local function ParseComparison(depth)
        local left = ParsePrimary(depth)
        local p = Peek()
        if p and (p.value == "==" or p.value == "~=" or p.value == "<" or p.value == ">" or p.value == "<=" or p.value == ">=") then
            local op = Consume().value
            local right = ParsePrimary(depth)
            return { op = op, left = left, right = right }
        end
        return left
    end

    local function ParseAnd(depth)
        local left = ParseComparison(depth)
        while Peek() and Peek().value == "and" do
            Consume()
            local right = ParseComparison(depth)
            left = { op = "and", left = left, right = right }
        end
        return left
    end

    function ParseExpr(depth)
        local left = ParseAnd(depth)
        while Peek() and Peek().value == "or" do
            Consume()
            local right = ParseAnd(depth)
            left = { op = "or", left = left, right = right }
        end
        return left
    end

    return ParseExpr(0)
end

function PGF.DoesPassThroughFilter(env, exp)
    if exp == nil or exp == "" or exp == "true" then return true end

    local tree
    if lastExpressionString == exp and lastCompiledTree then
        tree = lastCompiledTree
    else
        local status, tokensOrErr = pcall(Tokenize, exp)
        if not status then
            PGF.HandleSyntaxError(tokensOrErr)
            return true
        end

        local status2, treeOrErr = pcall(Parse, tokensOrErr)
        if not status2 then
            PGF.HandleSyntaxError(treeOrErr)
            return true
        end

        tree = treeOrErr
        lastExpressionString = exp
        lastCompiledTree = tree
    end

    local status, result = pcall(Evaluate, tree, env)
    if status then
        if type(result) == "boolean" then
            return result
        else
            PGF.HandleSemanticError("expression did not evaluate to boolean, but to '" .. tostring(result) .. "' of type " .. type(result))
            return true
        end
    else
        PGF.HandleSemanticError(result)
        return true
    end
end
