import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/pages/remove_stock_page.dart';
import 'package:squirrel_app/features/items/presentation/widgets/manage_item_tags_bottom_sheet.dart';

class ItemMenu extends StatefulWidget {
  final AuthToken token;
  final Item item;
  const ItemMenu({super.key, required this.token, required this.item});

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  // Show bottom modal view to manage tags
  void showTagModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ManageItemTagsBottomSheet(
          token: widget.token,
          itemId: widget.item.id,
        );
      },
    );
  }

  // Remove item after confirmation
  // and reload items
  // and try to pop back
  void _removeItem() async {
    final canRemove = await showShadDialog(
      animateIn: [FadeEffect(duration: const Duration(milliseconds: 100))],
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "Do you want to permanently delete item?",
            description: "This step cannot be reversed\nID:${widget.item.id}",
          ),
    );

    if (canRemove == true && mounted) {
      context.read<RemoveItemBloc>().add(
        EventRemoveItem(token: widget.token, itemId: widget.item.id),
      );

      context.read<ItemBloc>().add(
        GetItems(
          tokenparam: Tokenparam(
            token: AuthTokenModel(
              token: widget.token.token,
              expiry: widget.token.expiry,
            ),
            param: ItemsFilter(page: 1),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RemoveItemBloc, RemoveItemState>(
          listener: (context, state) {
            switch (state) {
              case RemoveItemError():
                showToast(
                  context: context,
                  desc: state.message,
                  isDestructive: true,
                );
              case ItemRemoved():
                showToast(context: context, desc: "Item removed permanently!");
                Navigator.of(context).maybePop();
              default:
            }
          },
        ),
      ],
      child: IconButton(
        onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final Offset offset = button.localToGlobal(Offset.zero);

          showMenu(
            popUpAnimationStyle: AnimationStyle(
              duration: const Duration(milliseconds: 100),
            ),
            color: Colors.white,
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + 40,
              offset.dx,
              offset.dy,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            menuPadding: const EdgeInsets.all(15),
            items: [
              PopupMenuItem(
                child: Row(
                  children: [
                    Text('Delete Item', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Icon(Icons.delete_forever, color: Colors.red),
                  ],
                ),
                onTap: _removeItem,
              ),

              PopupMenuItem(
                child: Row(
                  children: [
                    Text('Manage Tags', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Icon(Icons.tag, color: Colors.blue),
                  ],
                ),
                onTap: () => showTagModal(context),
              ),

              PopupMenuItem(
                child: Row(
                  children: [
                    Text('Remove Stock', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Icon(Icons.remove, color: Colors.red),
                  ],
                ),
                onTap:
                    () => {
                      showShadDialog(
                        animateIn: const [
                          FadeEffect(duration: Duration(milliseconds: 100)),
                        ],
                        context: context,
                        builder:
                            (context) => RemoveStockPage(
                              item: widget.item,
                              token: widget.token,
                            ),
                      ),
                    },
              ),
            ],
          );
        },
        icon: const Icon(Icons.more_vert, color: Colors.black),
      ),
    );
  }
}
