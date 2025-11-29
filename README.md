# Catch Me! - Jeu Roblox

## 🎮 Architecture du Projet

Ce projet utilise une architecture inspirée de Roblox Studio pour le développement d'un jeu de poursuite ("Catch Me!").

### Structure des Dossiers

```
catch_me/
│
├── ServerScriptService/          # Scripts côté serveur
│   ├── GameLoop/                 # Boucle principale du jeu
│   │   └── GameManager.lua       # Gestionnaire du jeu
│   ├── NPCs/                     # Scripts des PNJs
│   ├── Maps/                     # Gestion des cartes
│   ├── Config/                   # Configuration
│   │   └── GameConfig.lua        # Config du jeu
│   └── Modules/                  # Modules partagés serveur
│       ├── PlayerManager.lua     # Gestion des joueurs
│       └── MapManager.lua        # Gestion des cartes
│
├── LocalPlayer/                  # Scripts côté client
│   ├── LocalScripts/             # Scripts de contrôle local
│   │   └── PlayerController.lua  # Contrôleur du joueur
│   └── GUI/                      # Interface utilisateur
│       ├── Screens/              # Écrans de l'interface
│       │   └── HUD.lua           # Interface principale
│       └── ...
│
├── Modules/                      # Modules réutilisables
│   ├── GameModules/              # Modules de jeu
│   ├── PlayerModules/            # Modules de joueur
│   └── Utilities/                # Utilitaires
│       ├── Signals.lua           # Système de signaux
│       └── Tween.lua             # Animations tweens
│
├── Assets/                       # Ressources du jeu
│   ├── Models/                   # Modèles 3D
│   └── Sounds/                   # Sons et musiques
│
└── Config/                       # Configuration du jeu
    └── GameConfig.lua
```

---

## 📋 Composants Principaux

### 1. **GameManager.lua**
- Gère la boucle principale du jeu
- Contrôle les états du jeu (Waiting, Playing, Ended)
- Synchronise les joueurs et la logique générale

### 2. **PlayerManager.lua**
- Gère l'initialisation des joueurs
- Suit les statistiques de chaque joueur
- Gère l'ajout de points et les changements d'état

### 3. **MapManager.lua**
- Charge et gère les cartes disponibles
- Sélectionne les cartes de manière aléatoire
- Active/désactive les cartes

### 4. **PlayerController.lua** (Client)
- Gère les entrées du joueur (clavier)
- Contrôle le mouvement du personnage
- Communique avec le serveur

### 5. **HUD.lua** (Client)
- Affiche le score du joueur
- Affiche la santé du joueur
- Affiche l'état du jeu en temps réel

---

## 🚀 Utilisation

### Démarrer le serveur
Le `GameManager` démarre automatiquement quand le jeu charge.

### Joueurs
- Les joueurs sont automatiquement enregistrés quand ils rejoignent
- Leurs données sont supprimées quand ils partent
- Les statistiques sont mises à jour en temps réel

### Configuration
Modifiez `GameConfig.lua` pour ajuster les paramètres du jeu:
- Nombre minimum/maximum de joueurs
- Durée du jeu
- Vitesse de mouvement
- Récompenses, etc.

---

## 🛠️ Modules Utilitaires

### Signals.lua
Permet la communication entre scripts:
```lua
local signal = Signal.new()
signal:Fire(data)
signal:Connect(function(data) print(data) end)
```

### Tween.lua
Crée des animations fluides:
```lua
local tween = Tween:Create(part, 1, {Transparency = 0})
tween:Play()
```

---

## 📝 Convention de Code

- Noms en PascalCase pour les classes et modules
- Noms en camelCase pour les variables et fonctions
- Commentaires explicites avec emojis pour la clarté
- Logs structurés: `[NomModule]`

---

## 🎯 Prochaines Étapes

1. Créer des cartes dans ServerStorage
2. Ajouter des zones de spawn
3. Implémenter la détection de capture
4. Ajouter des effets sonores et visuels
5. Créer des écrans de menu (Menu Principal, GameOver)
6. Implémenter un classement des joueurs

---

**Version:** 1.0.0  
**Auteur:** Votre Nom  
**Date:** 29 Novembre 2025
# catch_me
