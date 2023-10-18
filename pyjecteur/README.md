# `pyjecteur`

## Obtenir un nix-shell avec `pyjecteur` (équivalent d'un virtualenv mais avec nix)

Installer nix (`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`) puis executer

```
nix-shell -A prod
```

## Documentation rapide

### `pyjecteur.widget.Widget`

Contient la logique d'interaction avec le module DMX-USB. Pour l'utiliser, il
suffit d'instancier l'objet puis d'appler la méthode `set_dmx`:
```python
def set_dmx(self, addr: int, data: bytes, addr_starting: int = 0) -> None:
    """
    Set dmx values that will be sent.

    If `auto_commit` is set to false, to provided configuration won't be
    sent but memorized until the next call to `Widget.commit()` (or a call
    to this function with `auto_commit = True`).
    """
```

Pour des interactions à plus haut niveau, continuez de lire

### `pyjecteur.lights.Universe`

Objet représentant un Univers.

```python
class Universe:
    """Represents a DMX universe.

    Manages the adress space and responsibles for sending DMX to widget when
    `Universe.update_dmx()` is called.
    """

    def __init__(self, widget):
        """
        Initializes the Universe

        widget must be a class providing `widget.set_dmx(data, address)`
        """

    def register(self, light: "AbstractLight", address: int) -> None:
        """
        Register a light at the specified address
        """

    def update_dmx(self, light: "AbstractLight", data: Union[bytearray, bytes]) -> None:
        """
        Update the dmx data of the specified light
        """
```

### Interéagir avec un projecteur

Globalement, il faut instancier l'objet représentant le projecteur puis
l'enregister sur son Univers (`Universe.register(light, address)`, ATTENTION
les addresses commencent à 0).

Ensuite il y a deux façon de changer les paramètres:

  1. Changer les attributs (`projo.pan = 100`)
  2. Changer les addresses directement avec la notation index (change la valeur
     à l'addresse `addresse_projo + index`)


## Déclaration d'un nouveau type de projecteur

S'inspirer du fichier `pyjecteur/fixtures.py`
