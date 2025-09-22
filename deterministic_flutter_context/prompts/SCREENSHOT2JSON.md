# Prompt d'extraction d'un screenshot vers Json Mini Figma
# Ce prompt n'est pas à utiliser, il est présent uniquement pour information.

# Prompt d'extraction d'un screenshot vers Json Mini Figma
# Ce prompt n'est pas à utiliser, il est présent uniquement pour information.

Tu es un extracteur UI strict. À partir du snapshot fourni, produis **UN SEUL** fichier JSON `design.json` au format **mini-Figma enrichi**.

---

## ⚠️ Contraintes obligatoires
- **Sortie** = UN SEUL bloc **JSON valide** (UTF-8), **sans texte parasite** ni commentaire.
- **Couverture totale** : aucun élément visuel du snapshot ne doit être omis. Chaque **icône, texte, bouton, champ, slider, séparateur, carte, container, image, divider** ⇢ **1 composant**.
- **IDs déterministes** : `<type>-<index>` ; l’**index** s’incrémente selon un **balayage top-left → bottom-right**. L’**ordre des `children`** suit le même balayage.
- **Ordre strict** : l’ordre des composants listés dans components[] doit suivre exactement l’ordre de qa.inventory (même séquence, sans permutation ni insertion).
- **Mesures** : tous les composants ont `bbox` **et** `sourceRect` (**px entiers**, jamais “unknown”). Par défaut, `bbox == sourceRect`. Si différents, l’expliquer dans `qa.assumptions`.
- **Texte** : copié **verbatim** (accents, majuscules, ponctuation, espaces insécables s’il y en a).
- **Accessibilité** : tous les **interactifs** (Button, IconButton, Input, Link, Checkbox, Slider, etc.) ont `a11y.ariaLabel`.
- **Couleurs** : hex `#RRGGBB`. Tenter la **mesure exacte** ; si estimation, fournir la valeur **et** une entrée `qa.assumptions` avec `confidence ∈ [0.6;0.9]`.
- **Couleurs référençables** : toute couleur utilisée dans style doit également exister dans tokens.colors. Si une nouvelle couleur est détectée, l’ajouter dans tokens.colors avec un nom sémantique (headerBackground, ghostButtonBg, presetCardBg, …) et réutiliser exactement le même hex dans le style.
- **Styles explicites** : `gaps`, `paddings`, `radius`, `borderWidth`, `shadow` doivent être présents dans `style` quand visibles ou déductibles (arrondis au **token** le plus proche).
- **Groupes visuels** (bandeau, section, carte) ⇢ modélisés par un **`Container`** ou une **`Card`** **parent** avec leurs styles (`backgroundColor`, `paddingX`, `paddingY`, `gap`, `borderColor`, `borderWidth`, `radius`, `shadow`).
- **Layout requis sur tout groupe** : pour chaque `Container` ou `Card` ayant des `children`, ajouter `layout`:  
  `{"type":"flex","direction":"row|column","gap":"xxs|xs|sm|md|lg|xl","align":"start|center|end","justify":"start|between|end"}`. Le `gap` est **un token** de `tokens.spacing`.
- **Bouton + icône** : si un pictogramme est visible, **ne jamais** l’encoder dans `text`. Utiliser `leadingIcon` (type `Icon` avec `iconName`) **ou** un enfant `Icon`.
- **Icon cliquable** : tout pictogramme vraisemblablement cliquable est un **`IconButton`** (pas `Icon`) + `a11y.ariaLabel`.
- **Slider enrichi** : inclure `style.activeTrack`, `style.inactiveTrack`, `style.thumbColor`, `style.trackHeight` **et** un enfant `Thumb` (type `Icon` ou `Circle`) avec `bbox` + `iconName` qualifié (`material.circle`, …). Ajouter `valueNormalized ∈ [0,1]` si position déductible.
- **Header** : si des éléments horizontaux occupent le haut de l’écran sur un **fond distinct**, les regrouper dans un `Container` parent avec `style.backgroundColor` et `layout:{direction:'row',align:'center',gap:'sm'}`.
- **leadingIcon objet** : leadingIcon doit être un objet {type:'Icon', iconName:'...', style:{...}} (pas une string), pour garantir portabilité et stylage.
- **Pas d’ornements inventés** : ne pas ajouter de `border*`/`shadow` s’ils **ne sont pas visibles**.
- **Taille écran** : `screen.size` = **dimensions intrinsèques** du fichier (naturalWidth/naturalHeight) — pas d’arrondi/normalisation.
- **Typographies référencées** : pour chaque `Text`, fournir `typographyRef ∈ {title,label,body,muted}` **en plus** de `fontSize`/`fontWeight`, mappé à `tokens.typography`. Si incertain, choisir la plus proche & consigner dans `qa.assumptions`.
- **Icônes nommées** : `iconName` **qualifié** quand identifiable (`material.more_vert`, `material.bolt`, …). Si inconnu, nom simple + assumption.
- **Types inconnus** : ne pas inventer. Utiliser `type:"Placeholder"` avec `text:"raison"` et le consigner dans `qa.assumptions`.

---

## 📐 Procédure interne
1) **Inventaire** : liste exhaustive **ordonnée** de tous les éléments perçus. Rendre cette liste dans `qa.inventory` (avec `roughType` + `roughText`).  
2) **Structuration** : 1 composant par item ; regrouper en `Container`/`Card` pour toute zone partagée (fond/cadre/section). Ajouter **systématiquement** un `layout` aux groupes.  
3) **Styles** : renseigner `style` pour **chaque** composant `{color, backgroundColor, borderColor, borderWidth, paddingX, paddingY, radius, shadow, fontSize, fontWeight, lineHeight, typographyRef}`.  
   - Boutons **pill** : `borderWidth`, `borderColor`, `radius:"xl"`.  
   - Sliders : propriétés citées + enfant `Thumb`.  
   - Icônes : `iconName` qualifié **et** `a11y` si interactif.  
   - Boutons composés : `leadingIcon` + `text` (sans emoji).
4) **Contrôle** :  
   - `qa.coverageRatio = components.length / inventory.length` → **doit être 1.0**.  
   - `qa.countsByType` (totaux par type).  
   - `qa.textCoverage` : `found[]` exhaustif, `missing[]` vide.  
   - `qa.missingAtoms` : éléments visibles non représentés (doit être vide).  
   - `qa.assumptions` : toute estimation (couleurs, bbox, typographieRef…) avec `confidence`.  
   - `qa.colorsUsed` : tableau des couleurs uniques vues, avec leur mapping vers tokens.colors (clé ou unmapped). unmapped doit être vide.
   - **Jamais** de “unknown” pour `bbox`/`sourceRect`.

---

## 🎨 Schéma obligatoire
```json
{
  "meta": { "version": "1.0", "screenName": "string", "snapshotRef": "string" },
  "tokens": {
    "colors": {
      "primary": "#RRGGBB",
      "onPrimary": "#RRGGBB",
      "background": "#RRGGBB",
      "surface": "#RRGGBB",
      "textPrimary": "#RRGGBB",
      "textSecondary": "#RRGGBB",
      "divider": "#RRGGBB",
      "accent": "#RRGGBB",
      "sliderActive": "#RRGGBB",
      "sliderInactive": "#RRGGBB",
      "sliderThumb": "#RRGGBB",
      "border": "#RRGGBB"
      /* autres couleurs sémantiques autorisées : ex. "headerBackground", "ghostButtonBg", ... */
    },
    "typography": {
      "fontFamilies": ["Roboto","sans-serif","unknown"],
      "fontSizes": { "xs":0,"sm":0,"md":0,"lg":0,"xl":0 },
      "fontWeights": { "regular":400,"medium":500,"bold":700 },
      "lineHeights": { "sm":0,"md":0,"lg":0 }
    },
    "spacing": { "xxs":0,"xs":0,"sm":0,"md":0,"lg":0,"xl":0 },
    "radius": { "sm":0,"md":0,"lg":0,"xl":0 },
    "shadow": { "sm":"...", "md":"...", "lg":"..." }
  },
  "screen": { "size": { "width":0,"height":0 }, "layout": { "orientation":"portrait","scrollable":true } },
  "components": [
    {
      "id":"...",
      "type":"...",
      "bbox":[0,0,0,0],
      "sourceRect":[0,0,0,0],
      "text":"...",
      "iconName":"...",
      "leadingIcon": { "type":"Icon", "iconName":"...", "style":{ "color":"#RRGGBB" } },
      "a11y":{ "ariaLabel":"..." },
      "style":{
        "backgroundColor":"#RRGGBB",
        "color":"#RRGGBB",
        "fontSize":0,
        "fontWeight":"regular",
        "typographyRef":"title|label|body|muted",
        "paddingX":0,
        "paddingY":0,
        "radius":"sm",
        "borderColor":"#RRGGBB",
        "borderWidth":1,
        "shadow":"sm"
      },
      "layout":{
        "type":"flex",
        "direction":"row|column",
        "gap":"sm",
        "align":"center",
        "justify":"start"
      },
      "children":[ ... ]
      /* champs spécifiques au type autorisés (p.ex. Slider: activeTrack, inactiveTrack, thumbColor, trackHeight, valueNormalized; etc.) */
    }
  ],
  "qa": {
    "inventory": [ { "idx":1, "roughType":"string", "roughText":"string-or-empty" } ],
    "countsByType": { "Text":0, "Button":0, "Icon":0, "IconButton":0, "Slider":0, "Container":0, "Card":0, "Placeholder":0 },
    "textCoverage": { "found":[ "...","..." ], "missing":[ "...","..." ] },
    "colorsUsed": [ { "hex":"#RRGGBB", "token":"primary" }, { "hex":"#AABBCC", "token":"headerBackground" } ],
    "missingAtoms": [],
    "coverageRatio": 0.0,
    "checklist": [
      "every visual element in snapshot has a component with bbox",
      "all texts copied verbatim",
      "colors extracted as hex",
      "interactive elements have a11y.ariaLabel",
      "no invented components",
      "units are px integers",
      "all groups represented as Container/Card with styles",
      "all groups include explicit layout"
    ],
    "assumptions": [],
    "openQuestions": [],
    "confidenceGlobal": 0.0
  }
}
```
**Ne produis QUE ce JSON final.**