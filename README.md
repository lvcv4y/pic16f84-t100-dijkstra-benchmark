# PIC16F84-T100 benchmark compiler

Exemple de compilation d'un benchmark embarquant un code malveillant arbitraire en RISC-V.

L'exécutable est par la suite utilisable via gem5 pour étudier le comportement d'un trojan hardware (le `PIC16F84-T100`).

## But

On cherche à simuler une attaque réaliste par le trojan, qui sera responsable de détourner l'exécution du benchmark vers le code malveillant. Une version altérée du code-source de gem5, qui simule la compromission, sera responsable pour détecter le passage d'une adresse "légitime", et la détourner vers une cible donnée (un code arbitraire).

On cherche donc à compiler un benchmark qui embarque un code arbitraire vers lequel le trojan détournera le flow d'exécution. Tout est définit dans le fichier `main.c` :
 - Le benchmark en lui-même. Ici, on fait tourner l'algorithme de Dijsktra sur un graphe généré aléatoirement.
 - Le code malveillant, contenu dans la fonction `trojan`.

Pour faciliter le détournement, on cherche à fixer l'emplacement du code malveillant dans l'espace d'adressage virtuel.

## Fonctionnement

On ajoute un *attribute* à la fonction `trojan`, pour la déplacer dans une section spécifique de l'exécutable. On utilise ensuite une configuration spécifique du linker `link.ld` pour fixer l'emplacement de ladite section à un emplacement donné.

On peut faire de même avec une fonction légitime pour rendre plus simple l'adresse de trigger. Dans cet exemple, on a:
 - L'adresse de trigger qui est `0x200038`
 - Le code malveillant arbitraire, qui commence à `0x401000`

À noter que cela fonctionne uniquement car gem5 n'a aucun mécanisme d'ASLR.

## Utilisation

### Dépendences

#### Package 
Pour obtenir l'exécutable, il est nécessaire d'avoir la [toolchain RISCV GNU](https://github.com/riscv-collab/riscv-gnu-toolchain?tab=readme-ov-file).
 - Sur les distributions Debian-based, disponible via le package `riscv64-unknown-elf` ou `riscv64-unknown-elf-gcc`.
 - Pour les distributions arch-based, une [version précompilée est disponible sur l'AUR](https://aur.archlinux.org/packages/riscv64-gnu-toolchain-elf-bin). Le binaire sera installé par défaut à `/opt/riscv64-gnu-toolchain-elf-bin/bin/riscv64-unknown-elf-gcc`.

#### Shell Nix
Un shell Nix est également disponible dans le dépôt. Une fois Nix installé exécuter `nix-shell` dans le dossier courant suffit à avoir la chaine de compilation.

### Compilation

#### Packages

La commande suivante permet de compiler `main.c` et d'obtenir un fichier linké `program` prêt à être exécuté :

```bash
riscv64-unknown-elf-gcc -no-pie -Wl,-T,link.ld -o program
```

#### Shell Nix

Un raccourci est disponible : `compile main.c` suffit à obtenir le binaire compilé souhaité `program`. La commande précédente fonctionne également.