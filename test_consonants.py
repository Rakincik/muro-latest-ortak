import re
import html

def get_consonants(text):
    text = html.unescape(text).lower()
    
    # Map Turkish letters to English equivalents
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c',
        '\u0307': '' # combining dot
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
        
    # Keep only lowercase letters
    text = re.sub(r'[^a-z]', '', text)
    
    # Strip vowels
    vowels = set('aeiou')
    consonants = "".join([c for c in text if c not in vowels])
    return consonants

# Test it
c1 = get_consonants('5549 sayılı SUÇ GELİRLERİNİN AKLANMASINI')
c2 = get_consonants('5549 sayl SU GELRLERNN AKLANMASININ NLENMES HAKKINDA KANUN')
print('c1:', repr(c1))
print('c2:', repr(c2))
