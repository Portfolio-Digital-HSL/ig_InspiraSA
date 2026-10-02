#!/usr/bin/env python3
"""Gera regras FSH com ^short e ^definition em português para os elementos dos
perfis que ainda herdam texto em inglês do FHIR R4.

Uso (na raiz do IG):
    npx sushi build . --snapshot          # 1ª passada
    python3 scripts/traducao_ptbr.py      # gera input/fsh/traducao/*.fsh
    npx sushi build . --snapshot          # 2ª passada, já em português

O script lê os snapshots em fsh-generated/resources, encontra elementos com
short/definition em inglês e escreve um RuleSet por perfil
(input/fsh/traducao/<id>.fsh), inserido no perfil por `* insert TraducaoPtBr<Nome>`.
Só sobrescreve o atributo que está em inglês: textos já definidos em português no
perfil ou herdados do BR-Core são preservados.

O dicionário TRAD usa o caminho do elemento sem fatias. A busca tenta, nesta
ordem: caminho completo, "<Recurso>:<último segmento>", "*:<último segmento>".
"""
import glob, json, os, re

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GERADOS = os.path.join(RAIZ, "fsh-generated", "resources")
SAIDA = os.path.join(RAIZ, "input", "fsh", "traducao")
EN = re.compile(r"\b(the|of|is|for|and|to|when|who|what|this|which|an|be|are|with|that|or|by|from)\b", re.I)

# (short, definition)
TRAD = {
    # ── genéricos ───────────────────────────────────────────────────────────
    "*:id": ("Identificador do elemento", "Identificador único do elemento dentro do recurso, para referências internas."),
    "*:extension": ("Extensões adicionais", "Extensões que acrescentam informação não prevista no modelo base."),
    "*:modifierExtension": ("Extensões que não podem ser ignoradas", "Extensões que alteram o significado do elemento e não podem ser ignoradas por quem não as reconhece."),
    "*:meta": ("Metadados do recurso", "Metadados mantidos pela infraestrutura: versão, data de atualização, perfis e etiquetas."),
    "*:implicitRules": ("Regras sob as quais o conteúdo foi criado", "Referência ao conjunto de regras usadas na criação do recurso."),
    "*:language": ("Idioma do conteúdo", "Idioma em que o recurso foi escrito."),
    "*:text": ("Narrativa legível do recurso", "Resumo textual do recurso, para leitura humana."),
    "*:contained": ("Recursos contidos", "Recursos inline sem existência independente fora deste recurso."),
    "*:url": ("URL canônica", "Identificador canônico, globalmente único, do artefato."),
    "*:identifier": ("Identificador de negócio", "Identificador externo atribuído ao recurso pelo sistema de origem."),
    "*:version": ("Versão", "Versão de negócio do artefato."),
    "*:name": ("Nome computável", "Nome legível por máquina."),
    "*:title": ("Título", "Nome legível por pessoas."),
    "*:status": ("Situação", "Situação do recurso no seu ciclo de vida."),
    "*:experimental": ("Uso experimental", "Indica que o artefato é para teste e não para uso real."),
    "*:date": ("Data", "Data da última alteração relevante."),
    "*:publisher": ("Publicador", "Organização ou pessoa responsável pela publicação."),
    "*:contact": ("Contato do publicador", "Dados de contato do publicador."),
    "*:description": ("Descrição", "Descrição em linguagem natural."),
    "*:useContext": ("Contexto de uso", "Contexto em que o conteúdo se aplica."),
    "*:jurisdiction": ("Jurisdição", "Jurisdição em que o artefato se aplica."),
    "*:purpose": ("Finalidade", "Por que o artefato existe."),
    "*:copyright": ("Direitos de uso", "Restrições de uso e publicação."),
    "*:approvalDate": ("Data de aprovação", "Data em que o publicador aprovou o conteúdo."),
    "*:lastReviewDate": ("Data da última revisão", "Data da última revisão do conteúdo."),
    "*:effectivePeriod": ("Período de vigência", "Período em que o artefato está vigente."),
    "*:sequence": ("Número sequencial", "Número que identifica a ocorrência dentro da lista."),
    "*:quantity": ("Quantidade", "Quantidade de serviços ou produtos."),
    "*:unitPrice": ("Valor unitário", "Valor de uma unidade."),
    "*:factor": ("Fator de preço", "Fator multiplicador aplicado ao valor."),
    "*:net": ("Valor total", "Quantidade multiplicada pelo valor unitário e pelo fator."),
    "*:udi": ("Identificador único de dispositivo", "Identificador único (UDI) do dispositivo usado."),
    "*:modifier": ("Modificadores do serviço", "Códigos que qualificam o serviço ou produto."),
    "*:programCode": ("Programa", "Programa ao qual o serviço se vincula."),
    "*:revenue": ("Centro de receita", "Código do departamento ou centro de receita."),
    "*:category": ("Categoria", "Classificação da ocorrência."),
    "*:productOrService": ("Procedimento ou produto", "Código do procedimento, serviço ou produto."),
    "*:noteNumber": ("Notas aplicáveis", "Números das notas que se aplicam."),
    "*:adjudication": ("Resultado da análise", "Resultado da análise pelo autorizador: valores e motivos."),
    "*:bodySite": ("Local anatômico", "Região anatômica."),
    "*:subSite": ("Sublocal anatômico", "Subdivisão do local anatômico."),
    "*:serviced[x]": ("Data ou período do atendimento", "Data ou período em que o serviço foi prestado."),
    "*:location[x]": ("Local do atendimento", "Onde o serviço foi prestado."),
    "*:code": ("Código", "Código que identifica o conceito."),
    "*:type": ("Tipo", "Tipo da ocorrência."),
    "*:value[x]": ("Valor", "Valor da ocorrência."),
    "*:system": ("Sistema de codificação", "URL do sistema de codificação."),
    "*:display": ("Descrição do código", "Representação textual do código."),
    "*:userSelected": ("Selecionado pelo usuário", "Indica que o código foi escolhido diretamente pelo usuário."),
    "*:coding": ("Código em um sistema de codificação", "Referência a um código de um sistema de codificação."),
    "*:detail": ("Detalhe", "Componente do item."),
    "*:subDetail": ("Subdetalhe", "Componente do detalhe."),
    "*:amount": ("Valor monetário", "Valor monetário."),
    "*:reason": ("Motivo", "Motivo da ocorrência."),
    "*:period": ("Período", "Intervalo de tempo."),

    # ── Extension ───────────────────────────────────────────────────────────
    "Extension": ("Extensão", "Extensão deste guia."),
    "Extension.url": ("Identificador da extensão", "URL que identifica a extensão."),
    "Extension.value[x]": ("Valor da extensão", "Valor da extensão."),
    "Extension.extension": ("Subextensão", "Componente da extensão."),
    "Extension.extension.url": ("Identificador da subextensão", "Nome do componente da extensão."),
    "Extension.extension.value[x]": ("Valor da subextensão", "Valor do componente da extensão."),
    "Extension.extension.extension": ("Extensões adicionais", "Extensões do componente."),

    # ── Appointment / ServiceRequest / Encounter / Location (resíduos BR-Core) ──
    "Appointment": ("Agendamento", "Agendamento de um evento de cuidado para data e hora definidas, entre paciente, profissionais e recursos."),
    "Appointment.serviceType": ("Tipo de serviço", "Tipo específico de serviço ou procedimento a ser realizado."),
    "Appointment.reasonCode": ("Motivo (código) do agendamento", "Códigos que expressam a justificativa do agendamento."),
    "Appointment.supportingInformation": ("Informações de apoio", "Recursos que dão contexto ao agendamento."),
    "Appointment.participant.required": ("Participação obrigatória?", "Indica se a presença do participante é obrigatória."),
    "ServiceRequest": ("Requisição de serviço", "Solicitação de procedimento, exame, tratamento ou outro serviço."),
    "ServiceRequest.basedOn": ("Plano ou requisição de origem", "Plano, proposta ou requisição que esta requisição cumpre."),
    "ServiceRequest.replaces": ("Requisição substituída", "Requisição anterior substituída por esta."),
    "ServiceRequest.subject": ("Paciente", "Indivíduo para quem o serviço é solicitado."),
    "ServiceRequest.encounter": ("Atendimento de origem", "Atendimento em que a requisição foi criada."),
    "ServiceRequest.asNeeded[x]": ("Pré-condições para realização", "Condição que deve ocorrer para que o serviço seja realizado."),
    "Encounter": ("Contato assistencial", "Interação entre o paciente e o serviço de saúde para prestação de cuidado ou avaliação."),
    "Encounter.episodeOfCare": ("Episódio de cuidado", "Episódio de cuidado ao qual o atendimento pertence."),
    "Encounter.hospitalization": ("Detalhes da internação", "Dados de admissão, origem, destino e desfecho da internação."),
    "Encounter.hospitalization.reAdmission": ("Reinternação", "Indica se é reinternação e o motivo."),
    "Encounter.hospitalization.dischargeDisposition": ("Desfecho da internação", "Situação do paciente na saída: alta, transferência, óbito, permanência."),
    "Encounter.serviceProvider": ("Estabelecimento responsável", "Estabelecimento responsável pelo atendimento."),
    "Location": ("Localização", "Local físico onde serviços são prestados e recursos ficam."),
    "Location.position": ("Coordenadas geográficas", "Latitude, longitude e altitude (WGS84)."),

    # ── Task ────────────────────────────────────────────────────────────────
    "Task": ("Tarefa", "Atividade a ser executada e acompanhada até a conclusão."),
    "Task.identifier": ("Identificador da tarefa", "Identificador de negócio da tarefa."),
    "Task.instantiatesCanonical": ("Protocolo aplicado", "Definição formal (PlanDefinition, ActivityDefinition) que a tarefa executa."),
    "Task.instantiatesUri": ("Protocolo externo aplicado", "URL de protocolo externo que a tarefa executa."),
    "Task.basedOn": ("Requisição de origem", "Requisição que a tarefa ajuda a cumprir."),
    "Task.groupIdentifier": ("Identificador do grupo de tarefas", "Identificador comum a tarefas criadas juntas."),
    "Task.partOf": ("Tarefa principal", "Tarefa da qual esta é uma etapa."),
    "Task.status": ("Situação da tarefa", "Situação no ciclo de trabalho: requested, received, accepted, rejected, ready, in-progress, on-hold, failed, completed, cancelled."),
    "Task.statusReason": ("Motivo da situação", "Motivo da situação atual, como negativa ou pendência."),
    "Task.businessStatus": ("Situação de negócio", "Situação específica do processo de negócio."),
    "Task.intent": ("Intenção", "Natureza da tarefa: proposta, plano ou ordem."),
    "Task.priority": ("Prioridade", "Urgência da tarefa."),
    "Task.code": ("Tipo de tarefa", "Código que identifica o tipo de tarefa."),
    "Task.description": ("Descrição", "Descrição em texto livre do que deve ser feito."),
    "Task.focus": ("Recurso sobre o qual a tarefa age", "Recurso que a tarefa avalia ou modifica."),
    "Task.for": ("Beneficiário", "Paciente em favor de quem a tarefa é executada."),
    "Task.encounter": ("Atendimento relacionado", "Atendimento durante o qual a tarefa foi criada."),
    "Task.executionPeriod": ("Período de execução", "Início e fim da execução."),
    "Task.authoredOn": ("Data de criação", "Data e hora de criação da tarefa."),
    "Task.lastModified": ("Data da última alteração", "Data e hora da última modificação."),
    "Task.requester": ("Solicitante", "Quem criou a tarefa."),
    "Task.performerType": ("Tipo de executante", "Tipo de profissional ou entidade que deve executar."),
    "Task.owner": ("Responsável", "Quem é responsável pela execução."),
    "Task.location": ("Local de execução", "Onde a tarefa deve ser executada."),
    "Task.reasonCode": ("Motivo (código)", "Por que a tarefa é necessária."),
    "Task.reasonReference": ("Motivo (referência)", "Recurso que justifica a tarefa."),
    "Task.insurance": ("Cobertura associada", "Coberturas relevantes para a tarefa."),
    "Task.note": ("Observações", "Comentários sobre a tarefa."),
    "Task.relevantHistory": ("Histórico (Provenance)", "Registros de proveniência das mudanças da tarefa."),
    "Task.restriction": ("Restrições de execução", "Limites de prazo, repetições e destinatários."),
    "Task.restriction.repetitions": ("Número de repetições", "Quantas vezes a tarefa deve ser executada."),
    "Task.restriction.period": ("Prazo", "Período em que a tarefa deve ser concluída."),
    "Task.restriction.recipient": ("Destinatários", "Para quem a tarefa é destinada."),
    "Task.input": ("Entradas", "Informações usadas na execução."),
    "Task.input.type": ("Tipo da entrada", "Código que identifica a entrada."),
    "Task.input.value[x]": ("Valor da entrada", "Conteúdo da entrada."),
    "Task.output": ("Resultados", "Resultados produzidos pela tarefa."),
    "Task.output.type": ("Tipo do resultado", "Código que identifica o resultado."),
    "Task.output.value[x]": ("Valor do resultado", "Conteúdo do resultado."),

    # ── Claim ───────────────────────────────────────────────────────────────
    "Claim": ("Solicitação ao pagador", "Solicitação de autorização prévia ou de pagamento apresentada ao gestor ou operadora."),
    "Claim.identifier": ("Identificador da solicitação", "Identificador de negócio da solicitação."),
    "Claim.status": ("Situação", "active, cancelled, draft ou entered-in-error."),
    "Claim.type": ("Tipo", "Categoria ampla: institucional, profissional, odontológica, farmácia, visão."),
    "Claim.subType": ("Subtipo", "Instrumento específico (APAC, AIH, BPA-I, RAAS)."),
    "Claim.use": ("Finalidade", "claim, preauthorization ou predetermination."),
    "Claim.patient": ("Paciente", "Paciente que recebeu ou receberá o cuidado."),
    "Claim.billablePeriod": ("Competência", "Período a que a solicitação se refere."),
    "Claim.created": ("Data de criação", "Data de criação da solicitação."),
    "Claim.enterer": ("Responsável pelo registro", "Quem registrou a solicitação."),
    "Claim.insurer": ("Gestor ou operadora", "Destinatário da solicitação."),
    "Claim.provider": ("Estabelecimento solicitante", "Responsável pela solicitação."),
    "Claim.priority": ("Prioridade", "Prioridade de processamento."),
    "Claim.fundsReserve": ("Reserva de recursos", "Pedido de reserva de recursos."),
    "Claim.related": ("Solicitações relacionadas", "Outras solicitações relacionadas a esta."),
    "Claim.related.claim": ("Solicitação relacionada", "Referência à solicitação relacionada."),
    "Claim.related.relationship": ("Tipo de relação", "Como as solicitações se relacionam."),
    "Claim.related.reference": ("Referência de arquivo", "Identificador de arquivo ou caso relacionado."),
    "Claim.prescription": ("Prescrição", "Prescrição que sustenta a solicitação."),
    "Claim.originalPrescription": ("Prescrição original", "Prescrição original quando houve substituição."),
    "Claim.payee": ("Beneficiário do pagamento", "Quem recebe o pagamento."),
    "Claim.payee.type": ("Tipo de beneficiário", "Categoria do beneficiário."),
    "Claim.payee.party": ("Beneficiário", "Referência ao beneficiário."),
    "Claim.referral": ("Requisição de origem", "Requisição clínica que originou a solicitação."),
    "Claim.facility": ("Local de atendimento", "Estabelecimento onde o serviço foi prestado."),
    "Claim.careTeam": ("Equipe", "Profissionais envolvidos."),
    "Claim.careTeam.provider": ("Profissional", "Referência ao profissional."),
    "Claim.careTeam.responsible": ("Responsável", "Indica o profissional responsável."),
    "Claim.careTeam.role": ("Função", "Função do profissional."),
    "Claim.careTeam.qualification": ("Qualificação (CBO)", "Ocupação ou qualificação do profissional."),
    "Claim.supportingInfo": ("Informações de apoio", "Informações adicionais que sustentam a solicitação, como laudos."),
    "Claim.supportingInfo.category": ("Categoria da informação", "Tipo de informação."),
    "Claim.supportingInfo.code": ("Código da informação", "Código específico da informação."),
    "Claim.supportingInfo.timing[x]": ("Data ou período", "Quando a informação se aplica."),
    "Claim.supportingInfo.value[x]": ("Valor", "Conteúdo da informação."),
    "Claim.supportingInfo.reason": ("Motivo", "Motivo da informação."),
    "Claim.diagnosis": ("Diagnósticos", "Diagnósticos relacionados."),
    "Claim.diagnosis.diagnosis[x]": ("Diagnóstico", "Código ou referência do diagnóstico."),
    "Claim.diagnosis.type": ("Tipo de diagnóstico", "Papel do diagnóstico: principal, secundário."),
    "Claim.diagnosis.onAdmission": ("Presente na admissão", "Indica se o diagnóstico existia na admissão."),
    "Claim.diagnosis.packageCode": ("Grupo de diagnóstico", "Código do pacote ou grupo de diagnóstico."),
    "Claim.procedure": ("Procedimentos clínicos", "Procedimentos clínicos realizados."),
    "Claim.procedure.type": ("Tipo de procedimento", "Categoria do procedimento."),
    "Claim.procedure.date": ("Data do procedimento", "Quando o procedimento foi realizado."),
    "Claim.procedure.procedure[x]": ("Procedimento", "Código ou referência do procedimento."),
    "Claim.insurance": ("Cobertura", "Coberturas ou arranjos de custeio aplicáveis."),
    "Claim.insurance.focal": ("Cobertura principal", "Indica a cobertura a ser usada nesta solicitação."),
    "Claim.insurance.identifier": ("Identificador junto ao pagador", "Identificador da solicitação no pagador."),
    "Claim.insurance.coverage": ("Cobertura", "Referência à Coverage."),
    "Claim.insurance.businessArrangement": ("Acordo de negócio", "Identificador de acordo com o pagador."),
    "Claim.insurance.preAuthRef": ("Número da autorização prévia", "Número da autorização prévia (APAC, AIH)."),
    "Claim.insurance.claimResponse": ("Resposta anterior", "Resposta de processamento anterior."),
    "Claim.accident": ("Acidente", "Detalhes de acidente relacionado."),
    "Claim.accident.date": ("Data do acidente", "Quando o acidente ocorreu."),
    "Claim.accident.type": ("Tipo de acidente", "Natureza do acidente."),
    "Claim.accident.location[x]": ("Local do acidente", "Onde o acidente ocorreu."),
    "Claim.item": ("Itens", "Procedimentos, produtos ou pacotes solicitados ou realizados."),
    "Claim.item.careTeamSequence": ("Equipe aplicável", "Sequência dos membros da equipe envolvidos."),
    "Claim.item.diagnosisSequence": ("Diagnósticos aplicáveis", "Sequência dos diagnósticos relacionados."),
    "Claim.item.procedureSequence": ("Procedimentos aplicáveis", "Sequência dos procedimentos relacionados."),
    "Claim.item.informationSequence": ("Informações aplicáveis", "Sequência das informações de apoio relacionadas."),
    "Claim.item.encounter": ("Atendimentos", "Atendimentos em que o item foi realizado."),
    "Claim.total": ("Valor total", "Valor total da solicitação."),

    # ── ClaimResponse ──────────────────────────────────────────────────────
    "ClaimResponse": ("Resposta do pagador", "Resultado do processamento de uma solicitação: autorização, negativa, crítica ou pagamento."),
    "ClaimResponse.identifier": ("Identificador da resposta", "Identificador de negócio da resposta."),
    "ClaimResponse.status": ("Situação", "active, cancelled, draft ou entered-in-error."),
    "ClaimResponse.type": ("Tipo", "Categoria ampla da solicitação respondida."),
    "ClaimResponse.subType": ("Subtipo", "Instrumento específico (APAC, AIH)."),
    "ClaimResponse.use": ("Finalidade", "claim, preauthorization ou predetermination."),
    "ClaimResponse.patient": ("Paciente", "Paciente a que se refere a resposta."),
    "ClaimResponse.created": ("Data da resposta", "Data de criação da resposta."),
    "ClaimResponse.insurer": ("Gestor ou operadora", "Quem emitiu a resposta."),
    "ClaimResponse.requestor": ("Solicitante", "Quem apresentou a solicitação."),
    "ClaimResponse.request": ("Solicitação respondida", "Referência à solicitação original."),
    "ClaimResponse.outcome": ("Resultado do processamento", "queued, complete, error ou partial."),
    "ClaimResponse.disposition": ("Mensagem do resultado", "Descrição textual do resultado."),
    "ClaimResponse.preAuthRef": ("Número da autorização", "Número da autorização prévia emitida."),
    "ClaimResponse.preAuthPeriod": ("Validade da autorização", "Período de validade da autorização."),
    "ClaimResponse.payeeType": ("Tipo de beneficiário", "Categoria de quem recebe o pagamento."),
    "ClaimResponse.item": ("Análise por item", "Resultado para cada item da solicitação."),
    "ClaimResponse.item.itemSequence": ("Item analisado", "Sequência do item na solicitação."),
    "ClaimResponse.item.adjudication.category": ("Tipo do valor", "Tipo de resultado: elegível, coparticipação, glosa."),
    "ClaimResponse.item.adjudication.reason": ("Motivo", "Motivo do resultado."),
    "ClaimResponse.item.adjudication.amount": ("Valor", "Valor monetário."),
    "ClaimResponse.item.adjudication.value": ("Valor não monetário", "Percentual ou quantidade."),
    "ClaimResponse.item.detail.detailSequence": ("Detalhe analisado", "Sequência do detalhe na solicitação."),
    "ClaimResponse.item.detail.subDetail.subDetailSequence": ("Subdetalhe analisado", "Sequência do subdetalhe na solicitação."),
    "ClaimResponse.addItem": ("Itens incluídos pelo pagador", "Itens acrescentados pelo pagador."),
    "ClaimResponse.addItem.itemSequence": ("Item relacionado", "Sequência do item da solicitação."),
    "ClaimResponse.addItem.detailSequence": ("Detalhe relacionado", "Sequência do detalhe da solicitação."),
    "ClaimResponse.addItem.subdetailSequence": ("Subdetalhe relacionado", "Sequência do subdetalhe da solicitação."),
    "ClaimResponse.addItem.provider": ("Prestadores autorizados", "Prestadores autorizados para o item."),
    "ClaimResponse.adjudication": ("Resultado geral", "Resultado da análise no nível da solicitação."),
    "ClaimResponse.total": ("Totais", "Totais por categoria."),
    "ClaimResponse.total.category": ("Categoria do total", "Tipo de total."),
    "ClaimResponse.total.amount": ("Valor", "Valor monetário do total."),
    "ClaimResponse.payment": ("Pagamento", "Detalhes do pagamento."),
    "ClaimResponse.payment.type": ("Tipo de pagamento", "Parcial ou integral."),
    "ClaimResponse.payment.adjustment": ("Ajuste", "Valor de ajuste."),
    "ClaimResponse.payment.adjustmentReason": ("Motivo do ajuste", "Motivo do ajuste."),
    "ClaimResponse.payment.date": ("Data do pagamento", "Data prevista ou efetiva."),
    "ClaimResponse.payment.identifier": ("Identificador do pagamento", "Identificador do pagamento."),
    "ClaimResponse.fundsReserve": ("Reserva de recursos", "Situação da reserva de recursos."),
    "ClaimResponse.formCode": ("Formulário de impressão", "Código do formulário."),
    "ClaimResponse.form": ("Formulário", "Formulário anexo."),
    "ClaimResponse.processNote": ("Notas do processamento", "Observações do pagador."),
    "ClaimResponse.processNote.number": ("Número da nota", "Identificador da nota."),
    "ClaimResponse.processNote.type": ("Tipo de nota", "display, print ou printoper."),
    "ClaimResponse.communicationRequest": ("Pedidos de informação", "Pedidos de informação adicional."),
    "ClaimResponse.insurance": ("Cobertura", "Coberturas consideradas."),
    "ClaimResponse.insurance.focal": ("Cobertura principal", "Indica a cobertura usada."),
    "ClaimResponse.insurance.coverage": ("Cobertura", "Referência à Coverage."),
    "ClaimResponse.insurance.businessArrangement": ("Acordo de negócio", "Identificador de acordo."),
    "ClaimResponse.insurance.claimResponse": ("Resposta anterior", "Resposta de processamento anterior."),
    "ClaimResponse.error": ("Críticas", "Erros encontrados no processamento."),
    "ClaimResponse.error.itemSequence": ("Item com crítica", "Sequência do item."),
    "ClaimResponse.error.detailSequence": ("Detalhe com crítica", "Sequência do detalhe."),
    "ClaimResponse.error.subDetailSequence": ("Subdetalhe com crítica", "Sequência do subdetalhe."),
    "ClaimResponse.error.code": ("Código da crítica", "Código do erro."),

    # ── PlanDefinition ─────────────────────────────────────────────────────
    "PlanDefinition": ("Definição de protocolo", "Definição de um conjunto de ações: protocolo, regra de decisão ou composição de oferta."),
    "PlanDefinition.subtitle": ("Subtítulo", "Subtítulo do protocolo."),
    "PlanDefinition.type": ("Tipo de definição", "order-set, clinical-protocol, eca-rule ou workflow-definition."),
    "PlanDefinition.subject[x]": ("Tipo de sujeito", "Tipo de indivíduo a que o protocolo se aplica."),
    "PlanDefinition.usage": ("Orientação de uso", "Como o protocolo deve ser usado."),
    "PlanDefinition.topic": ("Temas", "Categorias temáticas."),
    "PlanDefinition.author": ("Autores", "Quem elaborou o conteúdo."),
    "PlanDefinition.editor": ("Editores", "Quem editou o conteúdo."),
    "PlanDefinition.reviewer": ("Revisores", "Quem revisou o conteúdo."),
    "PlanDefinition.endorser": ("Endossantes", "Quem endossa o conteúdo."),
    "PlanDefinition.relatedArtifact": ("Artefatos relacionados", "Normas, documentação e artefatos dos quais depende."),
    "PlanDefinition.library": ("Lógica (Library)", "Bibliotecas com a lógica usada."),
    "PlanDefinition.goal": ("Metas", "Metas que o protocolo busca."),
    "PlanDefinition.goal.category": ("Categoria da meta", "Tipo de meta."),
    "PlanDefinition.goal.description": ("Descrição da meta", "O que a meta pretende."),
    "PlanDefinition.goal.priority": ("Prioridade da meta", "high, medium ou low."),
    "PlanDefinition.goal.start": ("Início da meta", "Quando a meta começa."),
    "PlanDefinition.goal.addresses": ("Problemas abordados", "Condições que a meta aborda."),
    "PlanDefinition.goal.documentation": ("Evidências da meta", "Documentação de apoio."),
    "PlanDefinition.goal.target": ("Alvos", "Valores alvo da meta."),
    "PlanDefinition.goal.target.measure": ("Parâmetro", "O que é medido."),
    "PlanDefinition.goal.target.detail[x]": ("Valor alvo", "Valor a ser atingido."),
    "PlanDefinition.goal.target.due": ("Prazo do alvo", "Tempo para atingir o alvo."),
    "PlanDefinition.action": ("Ações", "Ações que compõem o protocolo."),
    "PlanDefinition.action.prefix": ("Prefixo", "Rótulo para exibição."),
    "PlanDefinition.action.title": ("Título da ação", "Título da ação."),
    "PlanDefinition.action.description": ("Descrição da ação", "Descrição da ação."),
    "PlanDefinition.action.textEquivalent": ("Equivalente textual", "Versão em texto para sistemas sem suporte estruturado."),
    "PlanDefinition.action.priority": ("Prioridade", "Urgência da ação."),
    "PlanDefinition.action.code": ("Código da ação", "Código que identifica a ação, como o procedimento SIGTAP."),
    "PlanDefinition.action.reason": ("Motivo", "Por que a ação é executada."),
    "PlanDefinition.action.documentation": ("Documentação", "Material de apoio."),
    "PlanDefinition.action.goalId": ("Metas atendidas", "Metas a que a ação se refere."),
    "PlanDefinition.action.subject[x]": ("Tipo de sujeito", "Tipo de indivíduo da ação."),
    "PlanDefinition.action.trigger": ("Gatilho", "Quando a ação é disparada."),
    "PlanDefinition.action.condition": ("Condição", "Condição para aplicar a ação."),
    "PlanDefinition.action.condition.kind": ("Tipo de condição", "applicability, start ou stop."),
    "PlanDefinition.action.condition.expression": ("Expressão", "Expressão booleana da condição."),
    "PlanDefinition.action.input": ("Dados de entrada", "Dados necessários à ação."),
    "PlanDefinition.action.output": ("Dados de saída", "Dados produzidos pela ação."),
    "PlanDefinition.action.relatedAction": ("Ação relacionada", "Relação com outra ação."),
    "PlanDefinition.action.relatedAction.actionId": ("Ação de referência", "Identificador da ação relacionada."),
    "PlanDefinition.action.relatedAction.relationship": ("Tipo de relação", "before, after, concurrent etc."),
    "PlanDefinition.action.relatedAction.offset[x]": ("Intervalo", "Tempo entre as ações."),
    "PlanDefinition.action.timing[x]": ("Prazo ou momento", "Quando a ação deve ocorrer; na OCI, o prazo de conclusão."),
    "PlanDefinition.action.participant": ("Participantes", "Quem participa da ação."),
    "PlanDefinition.action.participant.type": ("Tipo de participante", "patient, practitioner, related-person ou device."),
    "PlanDefinition.action.participant.role": ("Função", "Função do participante."),
    "PlanDefinition.action.type": ("Tipo de ação", "create, update, remove ou fire-event."),
    "PlanDefinition.action.groupingBehavior": ("Agrupamento", "visual-group, logical-group ou sentence-group."),
    "PlanDefinition.action.selectionBehavior": ("Seleção", "Como as subações são selecionadas."),
    "PlanDefinition.action.requiredBehavior": ("Obrigatoriedade", "must, could ou must-unless-documented."),
    "PlanDefinition.action.precheckBehavior": ("Pré-seleção", "yes ou no."),
    "PlanDefinition.action.cardinalityBehavior": ("Repetição", "single ou multiple."),
    "PlanDefinition.action.definition[x]": ("Definição da ação", "ActivityDefinition ou PlanDefinition que descreve a ação."),
    "PlanDefinition.action.transform": ("Transformação", "StructureMap aplicado."),
    "PlanDefinition.action.dynamicValue": ("Valor dinâmico", "Valor calculado na aplicação."),
    "PlanDefinition.action.dynamicValue.path": ("Caminho", "Elemento que recebe o valor."),
    "PlanDefinition.action.dynamicValue.expression": ("Expressão", "Expressão que calcula o valor."),
    "PlanDefinition.action.action": ("Subações", "Ações componentes; na OCI, os procedimentos."),

    # ── ChargeItemDefinition ───────────────────────────────────────────────
    "ChargeItemDefinition": ("Definição de cobrança", "Regras de cobrança e preço de um procedimento ou pacote."),
    "ChargeItemDefinition.derivedFromUri": ("Norma de origem", "Norma ou documento de que a regra deriva."),
    "ChargeItemDefinition.partOf": ("Definição maior", "Definição da qual esta faz parte."),
    "ChargeItemDefinition.replaces": ("Definição substituída", "Definição anterior substituída."),
    "ChargeItemDefinition.code": ("Procedimento ou pacote", "Código do item cobrado."),
    "ChargeItemDefinition.instance": ("Instâncias", "Recursos específicos a que se aplica."),
    "ChargeItemDefinition.applicability": ("Condição de pagamento", "Condição que deve ser verdadeira para que a regra se aplique."),
    "ChargeItemDefinition.applicability.description": ("Descrição da condição", "Descrição em texto."),
    "ChargeItemDefinition.applicability.language": ("Linguagem", "Linguagem da expressão."),
    "ChargeItemDefinition.applicability.expression": ("Expressão", "Expressão que avalia a condição."),
    "ChargeItemDefinition.propertyGroup": ("Grupo de preço", "Componentes de preço e suas condições."),
    "ChargeItemDefinition.propertyGroup.applicability": ("Condições do grupo", "Condições do grupo de preço."),
    "ChargeItemDefinition.propertyGroup.priceComponent": ("Componente de preço", "Valor base, acréscimo, desconto ou tributo."),
    "ChargeItemDefinition.propertyGroup.priceComponent.type": ("Tipo de componente", "base, surcharge, deduction, discount, tax ou informational."),
    "ChargeItemDefinition.propertyGroup.priceComponent.code": ("Código do componente", "Código do componente."),
    "ChargeItemDefinition.propertyGroup.priceComponent.factor": ("Fator", "Fator aplicado."),
    "ChargeItemDefinition.propertyGroup.priceComponent.amount": ("Valor", "Valor monetário."),

    # ── MeasureReport ──────────────────────────────────────────────────────
    "MeasureReport": ("Relatório de medida", "Resultado do cálculo de uma medida para um período."),
    "MeasureReport.identifier": ("Identificador do relatório", "Identificador de negócio."),
    "MeasureReport.status": ("Situação", "complete, pending ou error."),
    "MeasureReport.type": ("Tipo de relatório", "individual, subject-list, summary ou data-collection."),
    "MeasureReport.measure": ("Medida", "Medida calculada."),
    "MeasureReport.subject": ("Sujeito", "Sujeito do relatório."),
    "MeasureReport.date": ("Data de geração", "Quando o relatório foi gerado."),
    "MeasureReport.reporter": ("Estabelecimento informante", "Quem informa os dados."),
    "MeasureReport.period": ("Período", "Período a que os dados se referem."),
    "MeasureReport.improvementNotation": ("Sentido de melhora", "Se valores maiores ou menores indicam melhora."),
    "MeasureReport.group": ("Grupo", "Resultados por grupo."),
    "MeasureReport.group.code": ("Código do grupo", "Identificação do grupo."),
    "MeasureReport.group.population": ("Contagens", "Contagens do grupo."),
    "MeasureReport.group.population.code": ("Tipo de contagem", "O que está sendo contado."),
    "MeasureReport.group.population.count": ("Quantidade", "Valor da contagem."),
    "MeasureReport.group.population.subjectResults": ("Lista de sujeitos", "Sujeitos incluídos na contagem."),
    "MeasureReport.group.measureScore": ("Escore", "Valor calculado da medida."),
    "MeasureReport.group.stratifier": ("Estratificação", "Resultados estratificados."),
    "MeasureReport.group.stratifier.code": ("Critério de estratificação", "Critério usado."),
    "MeasureReport.group.stratifier.stratum": ("Estrato", "Resultado de um estrato."),
    "MeasureReport.group.stratifier.stratum.value": ("Valor do estrato", "Valor que define o estrato."),
    "MeasureReport.group.stratifier.stratum.component": ("Componente do estrato", "Componente do critério."),
    "MeasureReport.group.stratifier.stratum.component.code": ("Código do componente", "Componente."),
    "MeasureReport.group.stratifier.stratum.component.value": ("Valor do componente", "Valor."),
    "MeasureReport.group.stratifier.stratum.population": ("Contagens do estrato", "Contagens no estrato."),
    "MeasureReport.group.stratifier.stratum.population.code": ("Tipo de contagem", "O que está sendo contado."),
    "MeasureReport.group.stratifier.stratum.population.count": ("Quantidade", "Valor da contagem."),
    "MeasureReport.group.stratifier.stratum.population.subjectResults": ("Lista de sujeitos", "Sujeitos do estrato."),
    "MeasureReport.group.stratifier.stratum.measureScore": ("Escore do estrato", "Valor calculado no estrato."),
    "MeasureReport.evaluatedResource": ("Recursos avaliados", "Recursos usados no cálculo."),
    # ── Sumário de Alta (Encounter, CarePlan, MedicationRequest/Timing) ───
    "Encounter.period.start": ("Data e hora da admissão", "Início da internação."),
    "Encounter.period.end": ("Data e hora da alta", "Fim da internação."),
    "*:doNotPerform": ("Não realizar", "Indica que a ação NÃO deve ser realizada."),
    "*:start": ("Início", "Data e hora de início do período."),
    "*:end": ("Fim", "Data e hora de término do período."),
    "MedicationRequest.dosageInstruction.timing.event": ("Momentos exatos", "Datas e horas em que a dose deve ser administrada."),
    "MedicationRequest.dosageInstruction.timing.repeat.bounds[x]": ("Limites do esquema", "Duração total ou período em que o esquema se aplica."),
    "MedicationRequest.dosageInstruction.timing.repeat.count": ("Número de repetições", "Quantas vezes a dose deve ser repetida."),
    "MedicationRequest.dosageInstruction.timing.repeat.countMax": ("Máximo de repetições", "Limite superior do número de repetições."),
    "MedicationRequest.dosageInstruction.timing.repeat.duration": ("Duração de cada administração", "Tempo de cada administração (ex.: infusão de 30 min)."),
    "MedicationRequest.dosageInstruction.timing.repeat.durationMax": ("Duração máxima", "Limite superior da duração de cada administração."),
    "MedicationRequest.dosageInstruction.timing.repeat.durationUnit": ("Unidade da duração", "Unidade de tempo da duração (s, min, h, d, wk, mo, a)."),
    "MedicationRequest.dosageInstruction.timing.repeat.frequency": ("Frequência", "Quantas vezes por período (ex.: 3 vezes ao dia)."),
    "MedicationRequest.dosageInstruction.timing.repeat.frequencyMax": ("Frequência máxima", "Limite superior da frequência."),
    "MedicationRequest.dosageInstruction.timing.repeat.period": ("Período", "Intervalo a que a frequência se refere (substitui o BRIntervaloDoses do SA-IG)."),
    "MedicationRequest.dosageInstruction.timing.repeat.periodMax": ("Período máximo", "Limite superior do período."),
    "MedicationRequest.dosageInstruction.timing.repeat.periodUnit": ("Unidade do período", "Unidade de tempo do período (s, min, h, d, wk, mo, a)."),
    "MedicationRequest.dosageInstruction.timing.repeat.dayOfWeek": ("Dias da semana", "Dias da semana em que a dose é administrada."),
    "MedicationRequest.dosageInstruction.timing.repeat.timeOfDay": ("Horário do dia", "Horário fixo da administração."),
    "MedicationRequest.dosageInstruction.timing.repeat.when": ("Turno ou evento", "Momento do dia ou evento (manhã, noite, antes das refeições). Substitui o BRTurno do SA-IG."),
    "MedicationRequest.dosageInstruction.timing.repeat.offset": ("Minutos do evento", "Minutos antes ou depois do evento indicado em when."),

}


R4 = os.path.expanduser(os.environ.get("FHIR_R4_CORE", "~/.fhir/packages/hl7.fhir.r4.core#4.0.1/package"))
_BASE = {}


def base(tipo):
    """Textos originais (inglês) do FHIR R4 para o tipo, por caminho."""
    if tipo not in _BASE:
        f = os.path.join(R4, "StructureDefinition-%s.json" % tipo)
        d = json.load(open(f, encoding="utf-8")) if os.path.exists(f) else {"snapshot": {"element": []}}
        _BASE[tipo] = {e["path"]: (e.get("short"), e.get("definition")) for e in d["snapshot"]["element"]}
    return _BASE[tipo]


def em_ingles(s):
    return bool(s) and bool(EN.search(s))


def caminho_norm(path):
    return re.sub(r":[^.]+", "", path)


def buscar(path):
    p = caminho_norm(path)
    rec, ult = p.split(".")[0], p.split(".")[-1]
    for k in (p, "%s:%s" % (rec, ult), "*:%s" % ult):
        if k in TRAD:
            return TRAD[k]
    # caminhos repetidos em detail/subDetail/addItem: tenta o caminho do item
    q = re.sub(r"\.(detail|subDetail|addItem)(?=\.)", ".item", p)
    q = re.sub(r"(\.item)+", ".item", q)
    if q in TRAD:
        return TRAD[q]
    # subações de PlanDefinition herdam o texto de action
    a = re.sub(r"(\.action)+", ".action", p)
    if a != p:
        return buscar(a)
    return None


def fsh_path(el_id):
    partes = el_id.split(".")[1:]
    out = []
    for parte in partes:
        if ":" in parte:
            nome, fatia = parte.split(":", 1)
            out.append("%s[%s]" % (nome, fatia))
        else:
            out.append(parte)
    return ".".join(out) if out else "."


def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


def main():
    os.makedirs(SAIDA, exist_ok=True)
    faltando = []
    titulos = {}
    for f in glob.glob(os.path.join(GERADOS, "StructureDefinition-*.json")):
        x = json.load(open(f, encoding="utf-8"))
        titulos[x["url"]] = (x.get("title"), x.get("description"))
    for f in sorted(glob.glob(os.path.join(GERADOS, "StructureDefinition-*.json"))):
        sd = json.load(open(f, encoding="utf-8"))
        regras = []
        for el in sd["snapshot"]["element"]:
            if el.get("max") == "0":
                continue  # elemento proibido: regra ^short o reativaria no SUSHI
            t = buscar(el["path"])
            if el["id"] == sd["type"]:
                t = (sd.get("title"), sd.get("description")) if sd.get("title") else t
            perfis_ext = [p for ty in el.get("type", []) if ty.get("code") == "Extension" for p in ty.get("profile", [])]
            if ":" in el["id"].split(".")[-1] and perfis_ext and perfis_ext[0] in titulos:
                t = titulos[perfis_ext[0]]
            b = base(el["path"].split(".")[0]).get(re.sub(r":[^.]+", "", el["path"]), (None, None))
            s0, d0 = el.get("short", ""), el.get("definition", "")
            precisa_s = em_ingles(s0) or s0 == b[0] or (t is not None and s0 == t[0])
            precisa_d = em_ingles(d0) or d0 == b[1] or (t is not None and d0 == t[1])
            if not (precisa_s or precisa_d):
                continue
            if not t:
                faltando.append("%s %s" % (sd["id"], el["id"]))
                continue
            p = fsh_path(el["id"])
            if precisa_s:
                regras.append('* %s ^short = "%s"' % (p, esc(t[0])))
            if precisa_d:
                regras.append('* %s ^definition = "%s"' % (p, esc(t[1])))
        nome = "TraducaoPtBr" + "".join(w.capitalize() for w in re.split(r"[-_]", sd["id"]))
        with open(os.path.join(SAIDA, sd["id"] + ".fsh"), "w", encoding="utf-8", newline="\n") as o:
            o.write("// GERADO por scripts/traducao_ptbr.py. Não edite à mão.\n")
            o.write("RuleSet: %s\n" % nome)
            o.write("\n".join(regras) + "\n" if regras else '* ^language = #pt-BR\n')
        print("%-28s %3d regras  (insert %s)" % (sd["id"], len(regras), nome))
    if faltando:
        print("\nSem tradução no dicionário:")
        print("\n".join(faltando))


if __name__ == "__main__":
    main()
