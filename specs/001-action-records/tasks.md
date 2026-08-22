# Tasks: Registros de Ação

**Input**: Design documents from `/specs/001-action-records/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create feature directory structure in `lib/features/registros_acao/` with `data/`, `providers/`, `presentation/`, `presentation/widgets/`
- [x] T002 [P] Verify Hive typeId 12 is available in registry
- [x] T003 [P] Add endpoint `registrosAcao` to `lib/core/api/endpoints.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story

- [x] T004 Create `RegistroAcao` model with Hive annotations in `lib/core/models/registro_acao.dart` (typeId: 12)
- [x] T005 [P] Create enum `TipoAcao` (REGA, ADUBACAO, TRANSPLANTE, OUTRO) in same file
- [x] T006 [P] Generate Hive adapter with `dart run build_runner build`
- [x] T007 Create `RegistroAcaoRepository` extending `CrudRepository<RegistroAcao>` in `lib/features/registros_acao/data/registros_acao_repository.dart`
- [x] T008 Create `RegistroAcaoState` and `RegistroAcaoNotifier` in `lib/features/registros_acao/providers/registros_acao_provider.dart`

**Checkpoint**: Foundation ready - user story implementation can begin

---

## Phase 3: User Story 1 - Criar Registro (Priority: P1) MVP

**Goal**: Criar registro de ação com campos obrigatórios e específicos por tipo

**Independent Test**: Criar registro de rega, verificar que salva corretamente

- [x] T009 [US1] Create `RegistroAcaoFormPage` in `lib/features/registros_acao/presentation/registro_acao_form_page.dart`
- [x] T010 [P] [US1] Create `RegistroAcaoTipoSelector` widget in `lib/features/registros_acao/presentation/widgets/registro_acao_tipo_selector.dart`
- [x] T011 [P] [US1] Create `RegistroAcaoDetalhesForm` widget in `lib/features/registros_acao/presentation/widgets/registro_acao_detalhes_form.dart`
- [x] T012 [US1] Implement form validation for required fields (tipo, data, cultivoId)
- [x] T013 [US1] Implement dynamic fields per action type (Rega: quantidade/metodo, Adubacao: produto/quantidade, Transplante: vaso/substrato)
- [x] T014 [US1] Add save button calling repository.create()
- [x] T015 [US1] Add error handling with SnackBar feedback
- [x] T016 [US1] Register route in GoRouter
- [x] T017 [US1] Add FAB to `CultivoDetailPage` in `lib/features/cultivos/presentation/cultivo_detail_page.dart`

---

## Phase 4: User Story 2 - Timeline e Filtros (Priority: P2)

**Goal**: Visualizar lista cronológica com filtros e paginação infinita

**Independent Test**: Criar registros, verificar timeline com paginação e filtros

- [x] T018 [US2] Create `RegistrosAcaoListPage` in `lib/features/registros_acao/presentation/registros_acao_list_page.dart`
- [x] T019 [P] [US2] Create `RegistroAcaoCard` widget in `lib/features/registros_acao/presentation/widgets/registro_acao_card.dart`
- [x] T020 [P] [US2] Create `RegistrosAcaoTimeline` widget in `lib/features/registros_acao/presentation/widgets/registros_acao_timeline.dart`
- [x] T021 [US2] Implement pagination with ScrollController (20 per load)
- [x] T022 [US2] Add filter chips for action type
- [x] T023 [US2] Add date range filter (semana, mes, customizado)
- [x] T024 [US2] Implement pull-to-refresh
- [x] T025 [US2] Add empty state widget

---

## Phase 5: User Story 3 - Editar e Excluir (Priority: P3)

**Goal**: Editar campos ou excluir registro com confirmacao

**Independent Test**: Criar, editar, excluir registro - verificar cada operacao

- [x] T026 [US3] Create `RegistroAcaoDetailPage` in `lib/features/registros_acao/presentation/registro_acao_detail_page.dart`
- [x] T027 [US3] Add edit button navigating to form with pre-filled data
- [x] T028 [US3] Implement edit mode in RegistroAcaoFormPage (receive existing record)
- [x] T029 [US3] Add delete button with ConfirmationDialog
- [x] T030 [US3] Implement delete with repository.delete()
- [x] T031 [US3] Add success SnackBar after edit/delete

---

## Phase 6: User Story 4 - Acao em Lote (Priority: P4)

**Goal**: Registrar mesma acao para multiplas plantas de uma vez

**Independent Test**: Selecionar 3 plantas, criar acao em lote, verificar 3 registros

- [ ] T032 [US4] Add toggle "Acao em Lote" in form page
- [ ] T033 [US4] Create plant selection widget (multi-select same environment)
- [ ] T034 [US4] Implement batch creation logic (loop selected plants)
- [ ] T035 [US4] Add batch progress indicator
- [ ] T036 [US4] Show success summary (X registros criados)

---

## Phase 7: User Story 5 - Fotos (Priority: P5)

**Goal**: Anexar ate 5 fotos a um registro

**Independent Test**: Criar registro com fotos, verificar exibicao no detalhe

- [ ] T037 [US5] Add photo section in form page (max 5)
- [ ] T038 [P] [US5] Integrate PhotoUploadButton from shared widgets
- [ ] T039 [US5] Implement photo upload with FotoService (entityType='REGISTRO_ACAO')
- [ ] T040 [US5] Add photo thumbnails with remove option
- [ ] T041 [US5] Display photos in detail page and timeline card

---

## Phase 8: User Story 6 - Offline (Priority: P6)

**Goal**: Registros offline salvos na fila com sincronizacao automatica

**Independent Test**: Desativar rede, criar registro, reativar - verificar sincronizacao

- [ ] T042 [US6] Integrate with OfflineOperation queue for create/update/delete
- [ ] T043 [US6] Add offline indicator in form page
- [ ] T044 [US6] Add sync status notification after reconnection
- [ ] T045 [US6] Handle conflict resolution (last writer wins)

---

## Phase 9: Polish & Cross-Cutting

**Purpose**: Final improvements and quality assurance

- [x] T046 [P] Run `flutter analyze` and fix any issues
- [x] T047 [P] Run `dart format lib/features/registros_acao/`
- [ ] T048 Add Semantics widgets for accessibility
- [ ] T049 Verify 48x48dp minimum touch targets
- [x] T050 Run quickstart.md validation scenarios

---

## Phase 10: Convergence

**Purpose**: Close gaps between spec/plan/tasks and actual implementation

- [x] T051 CRITICAL Register registros-acao routes in GoRouter (`lib/app/router.dart`) per plan: routing (missing)
- [x] T052 CRITICAL Add FAB "Registrar Ação" to `CultivoDetailPage` (`lib/features/cultivos/presentation/cultivo_detail_page.dart`) per spec: Ponto de Acesso (missing)
- [x] T053 HIGH Create `RegistrosAcaoTimeline` widget or update T020 status (`lib/features/registros_acao/presentation/widgets/registros_acao_timeline.dart`) per plan: structure (missing)
- [x] T054 MEDIUM Implement load-more pagination logic in `RegistrosAcaoListPage` per FR-6 (partial)
- [x] T055 MEDIUM Add date range filter (semana, mes, customizado) to list page per FR-6, T023 (partial)
- [x] T056 MEDIUM Add Semantics widgets for accessibility per Constitution VII (missing)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 - BLOCKS all user stories
- **Phases 3-8 (User Stories)**: Depend on Phase 2 completion
- **Phase 9 (Polish)**: Depends on all desired stories complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 - No dependencies on other stories
- **US2 (P2)**: Can start after Phase 2 - May display US1 data
- **US3 (P3)**: Depends on US1 (needs records to edit/delete)
- **US4 (P4)**: Depends on US1 (extends create functionality)
- **US5 (P5)**: Can start after Phase 2 - Independent photo feature
- **US6 (P6)**: Depends on US1 (offline applies to create flow)

### Recommended Execution Order

1. Phase 1 + Phase 2 (foundation)
2. US1 (MVP - create record)
3. US2 (timeline) + US3 (edit/delete) in parallel
4. US4 (batch) + US5 (photos) + US6 (offline) in parallel
5. Phase 9 (polish)

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: US1
4. **STOP and VALIDATE**: Test create record independently

### Incremental Delivery

1. Foundation ready -> US1 (MVP!) -> Deploy
2. + US2 (timeline) -> Deploy
3. + US3 (edit/delete) -> Deploy
4. + US4/US5/US6 -> Deploy
5. Polish -> Final release

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Each user story should be independently completable
- Commit after each task or logical group
- Stop at any checkpoint to validate independently
