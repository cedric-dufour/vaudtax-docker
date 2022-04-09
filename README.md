Containerized VaudTax installation for Linux
==

TL;DR:

* use in case your distribution fails to run VaudTax "natively"
  (e.g. because of missing dependencies)

* `export VAUDTAX_YEAR='2021'`

* build the Docker Image: [./build](./build)

* run the Docker Image: [./run](./run)

Other available environment variables:

* `VAUDTAX_DATA`: path to your VaudTax data, mounted in ` /home/vaudtax/data`;
  e.g. `export VAUDTAX_DATA="${HOME}"`

Official website: [VaudTax 2021](https://www.vd.ch/themes/etat-droit-finances/impots/impots-pour-les-individus/remplir-ma-declaration-dimpot/vaudtax-2021/)
