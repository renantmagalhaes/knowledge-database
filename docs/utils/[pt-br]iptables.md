# iptables (pt-br)

!!! note "Reference"
    <https://www.cyberciti.biz/faq/ubuntu-start-stop-iptables-service/>

## Quick reference (EN)

Run the following. It'll insert the rule at the top of your iptables and will allow all traffic unless subsequently handled by another rule.

```sh
iptables -I INPUT -j ACCEPT
```

You can also flush your entire iptables setup with the following:

```sh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
```

If you flush it, you might want to run something like:

```sh
iptables -A INPUT -i lo -j ACCEPT -m comment --comment "Allow all loopback traffic"
iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT -m comment --comment "Drop all traffic to 127 that doesn't use lo"
iptables -A OUTPUT -j ACCEPT -m comment --comment "Accept all outgoing"
iptables -A INPUT -j ACCEPT -m comment --comment "Accept all incoming"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow all incoming on established connections"
iptables -A INPUT -j REJECT -m comment --comment "Reject all incoming"
iptables -A FORWARD -j REJECT -m comment --comment "Reject all forwarded"
```

If you want to be a bit safer with your traffic, don't use the accept-all-incoming rule (or remove it with `iptables -D INPUT -j ACCEPT -m comment --comment "Accept all incoming"`), and add more specific rules like:

```sh
iptables -I INPUT -p tcp --dport 80 -j ACCEPT -m comment --comment "Allow HTTP"
iptables -I INPUT -p tcp --dport 443 -j ACCEPT -m comment --comment "Allow HTTPS"
iptables -I INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT -m comment --comment "Allow SSH"
iptables -I INPUT -p tcp --dport 8071:8079 -j ACCEPT -m comment --comment "Allow torrents"
```

!!! note
    They need to be above the 2 reject rules at the bottom, so use `-I` to insert them at the top. Or, use `iptables -nL --line-numbers` to get the line numbers, then `iptables -I INPUT ...` to insert a rule at a specific line number.

Finally, save your work with:

```sh
iptables-save > /etc/network/iptables.rules  # Or wherever your iptables.rules file is
```

## Conceitos

**==IPTABLES==**

- chains = onde as regras são armazenadas
- tables - armazenam as chains, cada tabela possui em média 3 chains

iptables é dividido em 3 tabelas:

- **Filter** - tabela padrão para filtragem mais simples como bloqueio de portas e protocolos
- **NAT** - quando há necessidade de realizar redirecionamento de trafego de dados para outras portas ou ips
- **Mangle** - alterações especiais no pacote

### IPTABLES - Chains

**--Filter--**

- INPUT - trafego de dados que chegam até a maquina
- OUTPUT - trafego de dados que saem da maquina
- FORWARD - Redirecionamento do trafego de dados da propria maquina para outra porta

**--NAT--**

- PREROUTING - trafego de dados que requerem alterações antes de serem roteáveis
- POSTROUTING - trafego de dados que requerem alterações depois de serem roteaveis
- OUTPUT - trafego de dados que saem do NAT

## Comandos de Gerenciamento

- `-L` = Lista as regras do iptables (padrão filter)
- `-t` = tabela (escolhe o tipo de tabela)

```sh
root@debian9:~# #iptables -L -t filter
root@debian9:~# #iptables -L -t nat
root@debian9:~# iptables -L -t mangle
```

```
root@debian9:~# iptables -L -t filter
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
root@debian9:~# iptables -L -t nat
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
root@debian9:~# iptables -L -t mangle
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
```

Caso não seja especificado a tabela para aplicar a regra, ou listar a regra, o iptables utilizara a tabela filter como padrão.

### Outros comandos

- `-d` = destino (adiciona um destino)
- `-s` = origem (adiciona uma origem)
- `-p` = protocolo (aplica as regras sobre o protocolo escolhido: tcp udp icmp)
- `--sport` = porta (define a porta de origem. Deve ser acompanhado da opção `-p`)
- `--dport` = porta (define a porta de destino. Deve ser acompanhado da opção `-p`)
- `-j` = ação (indica qual ação tomar quando a regra é criada). Ex:
    - `DROP` - Bloqueia trafego de dados
    - `REJECT` - Rejeita trafego de dados
    - `ACCEPT` - Aceita trafego de dados
- `!` = Exceção a regra que vier depois do `!`. Ex: nega tudo `!IP` (tudo será negado menos o IP declarado)
- `-i` = interface de entrada de dados
- `-o` = interface de saida de dados
- `-A chain` = Adiciona uma regra
- `-D $numero` = Deleta a regra de número X
- `-F` = Apaga todas as regras
- `-I chain $numero` = Insere uma regra de numero X na chain escolhida; se `$numero=1` é inserida a primeira regra

## SINTAXE

```
iptables [-t tabela] [opção] [chain] [dados] -j [ação]
```

Exemplo:

```sh
iptables -t filter -A FORWARD -d 192.168.1.1 -j DROP
```

A linha acima determina que todos os pacotes destinados a maquina 192.168.1.1 devem ser descartados.

```sh
iptables -t filter -A OUTPUT -d 192.168.0.200 -j DROP
```

Todos os pacotes vindos da maquina 192.168.0.200 serão descartados.

## MODULOS

Uma forma de aplicar regras mais aprimoradas, como por exemplo trabalhar sob uma analise do corpo do pacote.

Sintaxe:

```
-m <modulo>
-match <modulo>
```

Lista de modulos:

- `limit` = limita o numero de vezes em que uma regra será executada antes de passar para a proxima regra
- `state` = observa o estado da conexão (NEW, ESTABLISHED, RELATED, INVALID)
- `mac` = permite que o iptables trabalhe com endereçamentos MAC
- `multiport` = permite que sejam especificados até 15 portas a uma regra de uma só vez
- `string` = observa o conteudo do pacote para somente aplicar a regra

### -limit-

Evitar alguns tipos de ataque:

```sh
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp -j DROP
```

Essa regra acima diz que o host só poderá receber uma solicitação de ping por segundo; caso haja mais de uma por segundo, o pacote será dropado.

Intervalos validos em uma regra de limit:

- `/s` segundo
- `/m` minuto
- `/h` hora
- `/d` dia

### -state-

Atribui regras mediante a analise do estado da conexão de um pacote.

- `NEW` = indica que o pacote está criando uma nova conexão
- `ESTABLISHED` = informa que o pacote pertence a uma conexão já existente, logo trata-se de um pacote de resposta
- `RELATED` = pacotes relacionados indiretamente com outro pacote (ex: msg de erro de conexão)
- `INVALID` = pacotes não identificados por algum motivo desconhecido, geralmente é aconselhável que tais pacotes sejam descartados pelo firewall (DROP)

É possível utilizar mais do que apenas um estado de conexão por regra, separando cada estado por `,` (vírgula).

Exemplos:

```sh
iptables -A INPUT -m state --state NEW -i eth0 -j ACCEPT
# aceita pacotes novos indo para a interface eth0

iptables -A INPUT -m state --state INVALID -i eth0 -j DROP
# dropa pacotes invalidos indo para a eth0

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# todos os pacotes com os estados established e related serão aceitos independente da interface de entrada
```

### -mac-

Permite que o firewall atue na camada 2 do modelo OSI; a regra não dependeria mais do IP do host de origem, e sim do endereço MAC.

```sh
iptables -A INPUT -m mac --mac-source 64:1c:67:64:9f:5f -j DROP
```

### -multiport- (SINTAXE NAO FUNCIONOU)

Possibilita a adição de multiplas portas a um determinado alvo. Limite de 10 alvos por regra.

É possível usar o modulo multiport tanto para regras de destino (`--dport`) quanto de origem (`--sport`), ou usar apenas `--port` se quisermos aplicar a regra em portas de origem e destino ao mesmo tempo.

```sh
iptables -A INPUT -p tcp -i eth0 -m --multiport --dport 80,25,110,443 -j DROP
# bloqueando pacotes que entram na eth0 com destino nas portas listadas, com protocolo TCP

iptables -A INPUT -p tcp -i eth0 -m --multiport --port 80,443 -j DROP
# bloqueia pacotes que entrem pela interface eth0 tanto na origem quanto no destino
```

### -string- (sintaxe correta --modprobe=)

Modulo útil quando é preciso realizar controle de tráfego baseado no conteúdo do pacote.

```sh
iptables -A INPUT -m --string "porn" -j DROP
```

A regra acima estará bloqueando pacotes que tenham a palavra "porn" no corpo.

```sh
iptables -A INPUT -m --string "porn" -j LOG --log-prefix "Atenção: site de sexo"
iptables -A INPUT -m --string "porn" -j DROP
```

Grava a ocorrência no log e, na sequência, bloqueia.
