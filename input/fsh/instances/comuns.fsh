// Atores e contexto compartilhados pelos exemplos. Códigos e identificadores
// são ilustrativos; confirme CID-10, Tabela SUS e BRMedicamento na versão
// vigente antes de usar em testes de conformidade.

Instance: paciente-joao
InstanceOf: br-core-patient
Usage: #example
Title: "Paciente João Pereira"
Description: "Exemplo: Paciente João Pereira."
// raça/cor: extensão do IPS-BR, 1..1 no br-core-patient (FSH desde a 1.3.0)
* extension[0].url = $raca-br-ips
* extension[0].valueCodeableConcept = $BRRacaCor#03 "Parda"
* identifier[cpf].use = #official
* identifier[cpf].type = $v2-0203#TAX
* identifier[cpf].system = $sid-cpf
* identifier[cpf].value = "00000000272"
* identifier[cns].use = #official
* identifier[cns].type = $v2-0203#HC
* identifier[cns].system = $sid-cns
* identifier[cns].value = "700000000000013"
* name[0].given[0] = "João"
* name[0].family = "Pereira"
* gender = #male
* birthDate = "1954-07-22"

Instance: hospital-exemplo
InstanceOf: br-core-organization
Usage: #example
Title: "Hospital Exemplo"
Description: "Exemplo: Hospital Exemplo."
* identifier[cnes].use = #official
* identifier[cnes].type = $v2-0203#PRN
* identifier[cnes].system = $sid-cnes
* identifier[cnes].value = "0000003"
* name = "Hospital Exemplo"
* alias[0] = "HE"
* address[0].line[0] = "Rua Exemplo, 100"
* address[0].city = "São Paulo"
* address[0].state = "SP"
* address[0].country = "BR"

Instance: medica-alta
InstanceOf: br-core-practitioner
Usage: #example
Title: "Médica responsável pela alta"
Description: "Exemplo: Médica responsável pela alta."
* identifier[cns].use = #official
* identifier[cns].type = $v2-0203#HC
* identifier[cns].system = $sid-cns
* identifier[cns].value = "700000000000021"
* active = true
* name[0].given[0] = "Ana"
* name[0].family = "Souza"
