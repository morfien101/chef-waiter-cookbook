chef-waiter CHANGELOG
=========================

This file is used to list changes made in each version of the chef-waiter cookbook.

1.3.0
-------

Changed install_chef_waiter to delete it delete the chef waiter install file at the start of the run. This is to prevent situations where failed downloads cause servers to not have chef waiter installed.

1.1.2
-------

Updated the which_at and which_chefclient to be more os indepentdent.

1.1.1
-------

Changed the readme structure as minimart tries to read a directory called README as the readme file.

1.1.0
-------

Adding in better support for windows and updating the metadata file

1.0.1
-------

Inital public verion
