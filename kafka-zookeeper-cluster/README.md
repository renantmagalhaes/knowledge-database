# READ BEFORE PROCEED                                                             #
# Is required to read all the comments for this installation, there are some information that change accordingly the node/host

# DISCLAIMER
# This is guide is not written in stone, take time to read it, and change according your needs
# I use DNS entries to map my hosts, you can also use the private IP of the machines

#FOR PUBLIC CLOUDS
Open ports
    Zookeeper:
    - 2181
    - 2888
    - 3888
    
    Kafka:
    - 9092

# FOR ON-PREMISES
If using virtualbox or any other virtualization server maybe the zookeeper server wont start and show some type of "Connection Refuse" error. If that's the case is needed to set the server.x to 0.0.0.0 accordingly.

For example in host 1 is:
server.1=0.0.0.0:2888:3888
server.2=host-2:2888:3888
server.3=host-3:2888:3888

For example in host 2 is:
server.1=host-1:2888:3888
server.2=0.0.0.0:2888:3888
server.3=host-3:2888:3888

For example in host 3 is:
server.1=host-1:2888:3888
server.2=host-2:2888:3888
server.3=0.0.0.0:2888:3888

