# Loverseny Log

Helyi `C:\loverseny\loverseny.md` 3 percenkenti szinkronja GitHub Pages-en.

**Live URL:** https://ger15xxhcker.github.io/loverseny-log/

## Hogyan mukodik

1. `INDITAS.cmd` elinditja a push loop-ot
2. 3 percenkent ellenorzi `C:\loverseny\loverseny.md`-t
3. Ha valtozott: atmasolja repo-ba + `git push`
4. GitHub Pages ujraepiti az oldalt (~30-60 mp)
5. Bongeszoben az `index.html` 30 mp-enkent ujratolti a `.md`-t

## Files

- `index.html` - HTML viewer (marked.js + auto-refresh)
- `loverseny.md` - aktualis log tartalom (felulirja a push)
- `meta.json` - utolso frissites idobelyege
- `push_to_github.ps1` - helyi push loop
- `INDITAS.cmd` - launcher

## Inditas

```
INDITAS.cmd
```
