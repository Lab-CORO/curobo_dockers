
### Problème avec le package OpenCV

Lors de l'utilisation de la camera, il se peut que vous rencontriez l'erreur `AttributeError: module 'cv2.dnn' has no attribute 'DictValue'`
Pour resoudre cela, vous pouvez commenter la ligne 171 du fichier suivant :

```bash
nano /usr/local/lib/python3.10/dist-packages/cv2/typing/__init__.py
```

### Résolution du problème de symbole

Pour résoudre le problème de symbole manquant `ucm_set_global_opts`, veuillez exécuter le script ci-dessous à l'intérieur du conteneur Docker :

```bash
sudo apt-get update && sudo apt-get install --reinstall -y \
  libmpich-dev \
  hwloc-nox libmpich12 mpich
```

### Problèmes exclusifs à Windows

#### Incapacité de lancer les conteneurs

Dépendamment de la configuration du matériel, Docker pourrait ne pas fonctionner du tout dû à une absence de mémoire virtuelle. Pour régler cela, il suffit d'activer l'option de `virtualisation` du CPU dans votre BIOS. Le nom exacte de l'option et la méthode pour effectuer le changement variera d'un ordinateur à l'autre.

#### Incapacité de lancer de fenêtres à partir du Docker sur Windows

Le projet nécessite un `Xserver` pour lancer des fenêtres à partir du Docker sur l'ordinateur local. Une solution sous Windows est l'utilisation de [XLaunch](https://x.cygwin.com/docs/xlaunch/) disponible [ici](https://sourceforge.net/projects/vcxsrv/).

Préalablement au lancement initial du script `start_docker_x86.sh`, il faut:

- Lancer XLaunch. Choissisez les options par défaut, sauf pour la case `Disable access control` qu'il faut cocher.
- Dans le terminal que vous utiliserez pour lancer le script, effectuez:

  ```bash
  export DISPLAY=<adresse_IP>:0
  ```

  Votre adresse IP locale peut être trouvé grâce à la commande `ipconfig`
