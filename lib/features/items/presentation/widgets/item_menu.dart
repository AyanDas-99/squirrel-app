import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';

class ItemMenu extends StatelessWidget {
  final AuthToken token;
  final int itemId;
  const ItemMenu({super.key, required this.token, required this.itemId});

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
                  Text('Remove', style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.delete, color: Colors.red),
                ],
              ),
              onTap:
                  () => {
                    context.read<RemoveItemBloc>().add(
                      EventRemoveItem(token: token, itemId: itemId),
                    ),

                    context.read<ItemBloc>().add(
                      GetItems(
                        tokenparam: Tokenparam(
                          token: AuthTokenModel(
                            token: token.token,
                            expiry: token.expiry,
                          ),
                          param: ItemsFilter(page: 1),
                        ),
                      ),
                    ),
                    Navigator.of(context).maybePop(),
                  },
            ),
          ],
        );
      },
      child: const Icon(Icons.more_vert, color: Colors.black),
    );
  }
}
