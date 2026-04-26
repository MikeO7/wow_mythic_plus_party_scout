import os
import glob

locales = glob.glob('Localization/*.lua')
for file in locales:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace('L["addon.name.long"] = "Premade Groups Filter"', 'L["addon.name.long"] = "Mythic Plus Party Scout"')
    content = content.replace('L["addon.name.short"] = "PGF"', 'L["addon.name.short"] = "PartyScout"')
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)

print("Renamed strings in Locales")
