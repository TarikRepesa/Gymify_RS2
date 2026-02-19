import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/config/api_config.dart';
import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/dialogs/user_picker_dialog.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/image_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

import 'package:gymify_desktop/models/training.dart';
import 'package:gymify_desktop/models/user.dart';

import 'package:gymify_desktop/providers/image_provider.dart';
import 'package:gymify_desktop/providers/training_provider.dart';

Future<User?> showTrainerPickDialog({required BuildContext context}) {
  return showUserPickDialog(
    context: context,
    mode: PickMode.trainer,
    pageSize: 5,
  );
}

Widget TrainingWidget() {
  InputDecoration _searchDecoration() {
    return InputDecoration(
      hintText: "Pretraga po nazivu",
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: const Icon(Icons.search_rounded, size: 18),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFF387EFF), width: 1.6),
      ),
    );
  }

  String? _trainingImageToUrl(String? trainingImage) {
    if (!ImageHelper.hasValidImage(trainingImage)) return null;

    if (ImageHelper.isHttp(trainingImage!)) {
      return trainingImage;
    }

    // lokalno: wwwroot/images/training/<file>
    return "${ApiConfig.apiBase}/images/training/$trainingImage";
  }

  Future<void> _openAddTrainingDialog({
    required BuildContext context,
    required UniversalPagingProvider<Training> paging,
  }) async {
    final nameCtrl = TextEditingController();
    final maxCtrl = TextEditingController();
    final currentCtrl = TextEditingController(text: "0");
    final startDateCtrl = TextEditingController();
    final trainerDisplayCtrl = TextEditingController();

    int? trainerId;
    File? pickedImage;
    bool saving = false;

    String? errTrainer;
    String? errName;
    String? errMax;
    String? errCurrent;
    String? errStartDate;

    bool validate() {
      errTrainer = null;
      errName = null;
      errMax = null;
      errCurrent = null;
      errStartDate = null;

      if (trainerId == null) errTrainer = "Trener je obavezan.";
      if (nameCtrl.text.trim().isEmpty) errName = "Naziv je obavezan.";

      final maxText = maxCtrl.text.trim();
      final maxVal = int.tryParse(maxText);
      if (maxText.isEmpty) {
        errMax = "Max broj učesnika je obavezan.";
      } else if (maxVal == null || maxVal <= 0) {
        errMax = "Unesite validan broj (min 1).";
      }

      final curText = currentCtrl.text.trim();
      final curVal = int.tryParse(curText);
      if (curText.isEmpty) {
        errCurrent = "Trenutni broj učesnika je obavezan.";
      } else if (curVal == null || curVal < 0) {
        errCurrent = "Unesite validan broj (min 0).";
      }

      if (maxVal != null && curVal != null && curVal > maxVal) {
        errCurrent = "Trenutni broj ne može biti veći od max broja.";
      }

      final startUi = startDateCtrl.text.trim();
      if (startUi.isEmpty) {
        errStartDate = "Datum početka je obavezan.";
      } else {
        try {
          DateHelper.toIsoFromUi(startUi);
        } catch (_) {
          errStartDate = "Neispravan format datuma (dd.MM.yyyy).";
        }
      }

      return errTrainer == null &&
          errName == null &&
          errMax == null &&
          errCurrent == null &&
          errStartDate == null;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          Future<void> pickTrainer() async {
            final picked = await showTrainerPickDialog(context: dialogCtx);
            if (picked == null) return;

            trainerId = picked.id;
            trainerDisplayCtrl.text =
                "${picked.firstName ?? ""} ${picked.lastName ?? ""}".trim();

            setStateDialog(() {});
          }

          Future<void> pickImage() async {
            final file = await ImageHelper.openImagePicker();
            if (file == null) return;

            pickedImage = file;
            setStateDialog(() {});
          }

          Future<void> pickStartDate() async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: dialogCtx,
              initialDate: now,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked == null) return;

            final text =
                "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
            startDateCtrl.text = text;
            setStateDialog(() {});
          }

          Future<void> save() async {
            if (saving) return;

            final ok = validate();
            setStateDialog(() {});
            if (!ok) return;

            setStateDialog(() => saving = true);
            try {
              String? trainingImageFileName;

              if (pickedImage != null) {
                trainingImageFileName = await ImageAppProvider.upload(
                  file: pickedImage!,
                  folder: "training",
                );
              }

              final maxP = int.parse(maxCtrl.text.trim());
              final curP = int.parse(currentCtrl.text.trim());
              final startIso = DateHelper.toIsoFromUi(
                startDateCtrl.text.trim(),
              );

              await dialogCtx.read<TrainingProvider>().insert({
                "userId": trainerId,
                "name": nameCtrl.text.trim(),
                "maxAmountOfParticipants": maxP,
                "currentParticipants": curP,
                "startDate": startIso,
                "trainingImage": trainingImageFileName,
              });

              await paging.loadPage();
              if (dialogCtx.mounted) {
                SnackbarHelper.showSuccess(
                  dialogCtx,
                  "Trening uspješno dodan.",
                );
                Navigator.pop(dialogCtx);
              }
            } catch (e) {
              if (dialogCtx.mounted) {
                SnackbarHelper.showError(dialogCtx, e.toString());
              }
            } finally {
              if (dialogCtx.mounted) {
                setStateDialog(() => saving = false);
              }
            }
          }

          return BaseDialog(
            title: "Dodaj trening",
            width: 640,
            height: 680,
            onClose: () => Navigator.pop(dialogCtx),
            child: Builder(
              builder: (ctx) {
                final scrollCtrl = ScrollController();

                return PrimaryScrollController(
                  controller: scrollCtrl,
                  child: Scrollbar(
                    controller: scrollCtrl,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      primary:
                          true, // uzima controller iz PrimaryScrollController
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // IMAGE PICK + PREVIEW (opcionalno)
                          Container(
                            padding: const EdgeInsets.all(18),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.08),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x12000000),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    width: 170,
                                    height: 130,
                                    color: const Color(0xFFD0D6DD),
                                    child: pickedImage != null
                                        ? Image.file(
                                            pickedImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 55,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Slika treninga (opcionalno)",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        pickedImage != null
                                            ? pickedImage!.path
                                                  .split(Platform.pathSeparator)
                                                  .last
                                            : "Nije odabrana slika.",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.65),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      OutlinedButton.icon(
                                        onPressed: saving ? null : pickImage,
                                        icon: const Icon(
                                          Icons.photo_camera_outlined,
                                          size: 18,
                                        ),
                                        label: const Text("Odaberi sliku"),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // TRAINER PICK
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: trainerDisplayCtrl,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Trener",
                                    filled: true,
                                    fillColor: const Color(0xFFF7F7F7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorText: errTrainer,
                                    hintText:
                                        "Klikni 'Dodaj trenera' za odabir",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: saving ? null : pickTrainer,
                                  child: const Text("Dodaj trenera"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // NAME
                          TextField(
                            controller: nameCtrl,
                            decoration: InputDecoration(
                              labelText: "Naziv treninga",
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: errName,
                            ),
                            onChanged: (_) => setStateDialog(() {}),
                          ),

                          const SizedBox(height: 12),

                          // MAX
                          TextField(
                            controller: maxCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Max broj učesnika",
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: errMax,
                            ),
                            onChanged: (_) => setStateDialog(() {}),
                          ),

                          const SizedBox(height: 12),

                          // CURRENT MEMBERS
                          TextField(
                            controller: currentCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Trenutni broj učesnika",
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: errCurrent,
                            ),
                            onChanged: (_) => setStateDialog(() {}),
                          ),

                          const SizedBox(height: 12),

                          // START DATE PICK
                          TextField(
                            controller: startDateCtrl,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Datum početka",
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month_outlined),
                                onPressed: saving ? null : pickStartDate,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: errStartDate,
                            ),
                            onTap: saving ? null : pickStartDate,
                          ),

                          const SizedBox(height: 22),

                          // BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: saving
                                    ? null
                                    : () => Navigator.pop(dialogCtx),
                                child: const Text("Odustani"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: saving ? null : save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF387EFF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: saving
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Sačuvaj",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _card(Training t) {
    final title = t.name;
    final trainerName = "${t.user?.firstName ?? ""} ${t.user?.lastName ?? ""}"
        .trim();
    final trainer = trainerName.isEmpty ? "—" : trainerName;

    final members = t.currentParticipants;
    final startDateText = DateHelper.format(t.startDate);

    final imgUrl = _trainingImageToUrl(t.trainingImage);

    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 160,
              color: const Color(0xFFD0D6DD),
              child: imgUrl != null
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        // placeholder dok se slika učitava
                        return const Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black.withOpacity(0.12)),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.person, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trainer,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.people_alt_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                "$members",
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  startDateText,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF387EFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "PRIKAŽI DETALJE",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingControls(UniversalPagingProvider<Training> paging) {
    final totalPages =
        (paging.totalCount + paging.pageSize - 1) ~/ paging.pageSize;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: paging.hasPreviousPage
              ? () => paging.previousPage()
              : null,
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          totalPages == 0 ? "0 / 0" : "${paging.page + 1} / $totalPages",
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: paging.hasNextPage ? () => paging.nextPage() : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  return ChangeNotifierProvider<UniversalPagingProvider<Training>>(
    create: (context) {
      final paging = UniversalPagingProvider<Training>(
        pageSize: 6,
        fetcher:
            ({
              required int page,
              required int pageSize,
              String? filter,
              bool includeTotalCount = true,
            }) {
              return context.read<TrainingProvider>().get(
                filter: {
                  "page": page,
                  "pageSize": pageSize,
                  "includeTotalCount": includeTotalCount,
                  if (filter != null && filter.trim().isNotEmpty)
                    "FTS": filter.trim(),
                  "IncludeUser": true,
                },
              );
            },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Training>>(
      builder: (context, paging, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Grupni treninzi",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: _searchDecoration(),
                      onChanged: (v) => paging.search(v),
                    ),
                  ),
                  const SizedBox(width: 18),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => _openAddTrainingDialog(
                        context: context,
                        paging: paging,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387EFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text(
                        "DODAJ NOVI TRENING",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child: paging.isLoading && paging.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : paging.items.isEmpty
                    ? const Center(
                        child: Text(
                          "Nema podataka.",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 18),
                            child: Wrap(
                              spacing: 60,
                              runSpacing: 30,
                              children: paging.items.map(_card).toList(),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              _pagingControls(paging),
            ],
          ),
        );
      },
    ),
  );
}
