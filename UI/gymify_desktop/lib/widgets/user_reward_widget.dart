import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/models/user_reward.dart';
import 'package:gymify_desktop/providers/user_reward_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

Widget UserRewardWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<UserReward>>(
    create: (context) {
      final paging = UniversalPagingProvider<UserReward>(
        pageSize: 5,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<UserRewardProvider>().get(
            filter: {
              "page": page,
              "pageSize": pageSize,
              "includeTotalCount": includeTotalCount,
              if (filter != null && filter.trim().isNotEmpty)
                "fts": filter.trim(),
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<UserReward>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<UserReward>(
          title: "Kodovi",
          addButtonText: "",
          onAdd: null,
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),
          isLoading: paging.isLoading,
          items: paging.items,
          columns: [
            BaseColumn<UserReward>(
              title: "Korisnik",
              flex: 2,
              cell: (ur) => Text(_userName(ur)),
            ),
            BaseColumn<UserReward>(
              title: "Reward",
              flex: 2,
              cell: (ur) => Text(_rewardName(ur)),
            ),
            BaseColumn<UserReward>(
              title: "Kod",
              flex: 2,
              cell: (ur) => Text(
                (ur.code ?? "").isEmpty ? "-" : ur.code!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            BaseColumn<UserReward>(
              title: "Status",
              flex: 1,
              cell: (ur) => _StatusChip(status: ur.status),
            ),
            BaseColumn<UserReward>(
              title: "Redeemano",
              flex: 2,
              cell: (ur) => Text(DateHelper.format(ur.redeemedAt)),
            ),
          ],
          onEdit: (ur) async {
            if (ur.status != "Active") {
              SnackbarHelper.showError(
                context,
                "Samo aktivan kod možeš promijeniti u Used.",
              );
              return;
            }

            await showBaseFormDialog(
              context: context,
              title: "Ažuriraj status koda",
              initialValues: {
                "user": _userName(ur),
                "reward": _rewardName(ur),
                "code": ur.code ?? "",
                "status": ur.status,
              },
              fieldsDef: const [
                BaseFormFieldDef(
                  name: "user",
                  label: "Korisnik",
                  readOnly: true,
                  enabled: false,
                ),
                BaseFormFieldDef(
                  name: "reward",
                  label: "Reward",
                  readOnly: true,
                  enabled: false,
                ),
                BaseFormFieldDef(
                  name: "code",
                  label: "Kod",
                  readOnly: true,
                  enabled: false,
                ),
                BaseFormFieldDef(
                  name: "status",
                  label: "Status",
                  type: BaseFieldType.dropdown,
                  requiredField: true,
                  items: [
                    DropdownMenuItem<String>(
                      value: "Used",
                      child: Text("Used"),
                    ),
                  ],
                ),
              ],
              onSubmit: (payload) async {
                try {
                  await context.read<UserRewardProvider>().update(
                    ur.id,
                    {
                      "status": (payload["status"] ?? "").toString(),
                    },
                  );

                  await paging.loadPage();
                  SnackbarHelper.showUpdate(
                    context,
                    "Status user reward-a je uspješno ažuriran.",
                  );
                } catch (e) {
                  SnackbarHelper.showError(context, e.toString());
                  rethrow;
                }
              },
            );
          },
          onDelete: null,
          footer: _pagingControls(paging),
        );
      },
    ),
  );
}

String _userName(UserReward ur) {
  final user = ur.user;
  if (user == null) return "Korisnik #${ur.userId}";

  final fullName = "${user.firstName ?? ""} ${user.lastName ?? ""}".trim();
  if (fullName.isNotEmpty) return fullName;

  final username = (user.username ?? "").trim();
  if (username.isNotEmpty) return username;

  return "Korisnik #${ur.userId}";
}

String _rewardName(UserReward ur) {
  final reward = ur.reward;
  if (reward == null) return "Reward #${ur.rewardId}";
  return reward.name;
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String text;

    switch (status) {
      case "Used":
        color = Colors.red;
        text = "Used";
        break;
      case "Expired":
        color = Colors.orange;
        text = "Expired";
        break;
      default:
        color = Colors.green;
        text = "Active";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

Widget _pagingControls<T>(UniversalPagingProvider<T> paging) {
  final totalPages =
      (paging.totalCount + paging.pageSize - 1) ~/ paging.pageSize;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        onPressed: paging.hasPreviousPage ? () => paging.previousPage() : null,
        icon: const Icon(Icons.arrow_back),
      ),
      Text(
        totalPages == 0 ? "0 / 0" : "${paging.page + 1} / $totalPages",
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      IconButton(
        onPressed: paging.hasNextPage ? () => paging.nextPage() : null,
        icon: const Icon(Icons.arrow_forward),
      ),
    ],
  );
}