import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/pages/remove_stock_page.dart';
import 'package:squirrel_app/features/items/presentation/widgets/manage_item_tags_bottom_sheet.dart';

class ItemMenu extends StatefulWidget {
  final AuthToken token;
  final int itemId;
  const ItemMenu({super.key, required this.token, required this.itemId});

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  void showTagModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ManageItemTagsBottomSheet(
          token: widget.token,
          itemId: widget.itemId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final Offset offset = button.localToGlobal(Offset.zero);

        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + 40,
            offset.dx,
            offset.dy,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          items: [
            PopupMenuItem(
              child: Row(
                children: [
                  Text('Delete Item', style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.delete_forever, color: Colors.red),
                ],
              ),
              onTap:
                  () => {
                    context.read<RemoveItemBloc>().add(
                      EventRemoveItem(
                        token: widget.token,
                        itemId: widget.itemId,
                      ),
                    ),

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
                    ),
                    Navigator.of(context).maybePop(),
                  },
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
                  Icon(Icons.delete, color: Colors.red),
                ],
              ),
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RemoveStockPage(
                              itemId: widget.itemId,
                              token: widget.token,
                            ),
                      ),
                    ),
                  },
            ),
          ],
        );
      },
      child: const Icon(Icons.more_vert, color: Colors.black),
    );
  }
}
