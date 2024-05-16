import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Decoration/icons.dart';

import 'package:universal_dice/Main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  print(iconButtonDrawer);
  print("");
  print(iconRadioButtonChecked);
  print(iconRadioButtonUnchecked);
  print("");
  print(iconButtonModeDiceGroup);
  print(iconButtonModeDice);
  print("");
  print(iconButtonEditDiceGroup);
  print(iconButtonEditDice);
  print("");
  print(iconButtonDuplicateDiceGroup);
  print(iconButtonDuplicateDice);
  print("");
  print(iconButtonDeleteDiceGroup);
  print(iconButtonDeleteDice);
  print("");
  print(iconButtonAddDiceGroup);
  print(iconButtonAddDice);

  testWidgets("Интеграционное тестирование приложения целиком", (WidgetTester tester) async {
    Future<void> tapButton(Finder finder) async {
      expect(finder, findsAny, reason: "Не найдена кнопка на которую надо нажать");
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(const MyApp());
    int numberDiceGroup = 1;
    int numberDice = 3;

    /// тестирование работоспособности экрана загрузки кубиков
    expect(find.text("Загрузка игральных костей..."), findsOneWidget, reason: "Надпись 'Загрузка игральных костей...' не появилась или загрузка прошла слишком быстро");
    await tester.pumpAndSettle(); // дожидаемся загрузки кубиков из памяти   //await tester.pumpAndSettle(const Duration(microseconds: 500));
    expect(find.text("Загрузка игральных костей..."), findsNothing, reason: "Надпись 'Загрузка игральных костей...' не пропала или загрузка прошла слишком долго");

    /// тестирование начального экрана
    expect(find.text("Универсальные игральные кости"), findsOneWidget, reason: "Не отображается название");
    expect(find.text("Добро пожаловать! Выберите какие кубики кидать, нажав на кнопку в верхнем углу или свапнув вбок."), findsOneWidget,
        reason: "Не поприветствовали наших пользователей! Не отображается начальная инструкция");
    expect(find.text("Бросить все игральные кости"), findsNothing, reason: "Кнопка броска кубика не пропала хотя кубиков нет");

    final buttonDrawer = find.byIcon(iconButtonDrawer);
    expect(buttonDrawer, findsNWidgets(2), reason: "Найдено не две кнопки выбора кубиков");

    /// тестирование Drawer
    {
      await tapButton(buttonDrawer.last);
      expect(find.text("Выберите используемые кости"), findsOne, reason: "Не появился заголовок у Drawer, или он целиком не появился");
      expect(find.text("Стандартная группа"), findsOne, reason: "Не отображается начальная группа");

      /// тестирование взаимодействия с группой
      {
        /// тестирование добавления новой группы
        {
          await tapButton(find.byIcon(iconButtonAddDiceGroup).last);
          numberDiceGroup++;
          expect(find.byIcon(iconButtonModeDiceGroup), findsNWidgets(numberDiceGroup), reason: "Не добавилась новая группа");
        }

        /// тестирование кнопки редактировать группу
        {
          await tapButton(find.byIcon(iconButtonModeDiceGroup).first);
          final buttonEditDiceGroup = find.byIcon(iconButtonEditDiceGroup);
          expect(buttonEditDiceGroup, findsOne, reason: "Не отображается иконка редактирования группы");

          await tapButton(buttonEditDiceGroup);

          /// тестирование окна редактирования группы
          {
            expect(find.text("Редактирование группы"), findsOne, reason: "Нет заголовка окна редактирования группы");
            expect(find.text("Название группы:"), findsOne, reason: "Нет подписи к полю название в окне редактирования группы");
            final fieldInputName = find.byType(TextField);
            expect(fieldInputName, findsOne, reason: "Нет поля изменения названия");
            expect(find.byType(ElevatedButton), findsNWidgets(2), reason: "Нет кнопок в нижней части экрана");

            /// тестирование изменения названия группы
            {
              await tester.enterText(fieldInputName, "Название 1");
              await tester.pumpAndSettle();
              expect(find.text("Название 1"), findsOne, reason: "Название группы не ввелось в поле");
            }

            /// тестирование кнопки 'Отмена' в окне окне редактирования группы
            {
              final buttonCancel = find.text("Отмена");
              expect(buttonCancel, findsOne, reason: "Нет надписи 'Отмена' в окне редактирования группы");

              await tapButton(buttonCancel);
              expect(find.text("Редактирование группы"), findsNothing, reason: "Не пропало окно редактирования группы после 'Отмена'");
              expect(find.text("Название 1"), findsNothing, reason: "Название группы изменилось при 'Отмена'");
              expect(buttonEditDiceGroup, findsOne, reason: "Окно с выбором действий для группы пропало после кнопки 'Отмена'");
            }

            await tapButton(buttonEditDiceGroup);

            /// тестирование кнопки 'Сохранить' в окне окне редактирования группы
            {
              await tester.enterText(fieldInputName, "Название 2");
              await tester.pumpAndSettle();
              final buttonSave = find.text("Сохранить");
              expect(buttonSave, findsOne, reason: "Нет надписи 'Сохранить' в окне редактирования группы");

              await tapButton(buttonSave);
              expect(find.text("Редактирование группы"), findsNothing, reason: "Не пропало окно редактирования группы после 'Сохранить'");
              expect(find.text("Название 2"), findsOne, reason: "Название группы не изменилось после 'Сохранить'");
              expect(buttonEditDiceGroup, findsNothing, reason: "Окошко с выбором действий для группы осталось после кнопки 'Сохранить'");
            }
          }
        }

        /// тестирование кнопки дублирования группы
        {
          await tapButton(find.byIcon(iconButtonModeDiceGroup).first);
          final buttonDuplicateDiceGroup = find.byIcon(iconButtonDuplicateDiceGroup);
          expect(buttonDuplicateDiceGroup, findsOne, reason: "Не отображается иконка дублирования группы");

          await tapButton(buttonDuplicateDiceGroup);
          numberDiceGroup++;
          expect(find.byIcon(iconButtonModeDiceGroup), findsNWidgets(numberDiceGroup), reason: "Группа не дублировалась");
          expect(find.text("Название 2"), findsNWidgets(2), reason: "Дублировалась не та группа");
          //expect(find.byIcon(iconButtonModeDice), findsNWidgets(3), reason: "Группа добавилась свёрнутой или iconButtonModeDice не отображаются");
        }

        /// тестирование кнопки удаления группы
        {
          await tapButton(find.byIcon(iconButtonModeDiceGroup).first);
          final buttonDeleteDiceGroup = find.byIcon(iconButtonDeleteDiceGroup);
          expect(buttonDeleteDiceGroup, findsOne, reason: "Не отображается иконка удаления группы");

          await tapButton(buttonDeleteDiceGroup);

          /// тестирование окна подтверждения у группы
          {
            expect(find.text("Удалить группу с игральными костями?"), findsOne, reason: "Не отображается заголовок окна подтверждения удаления группы");
            expect(find.text("Группа \"Название 2\" будет удалена со всем содержимым."), findsOne, reason: "Не отображается основной текст окна подтверждения удаления группы");
            expect(find.byType(ElevatedButton), findsNWidgets(2), reason: "Нет кнопок в нижней части экрана подтверждения удаления группы");

            /// тестирование кнопки 'Отмена' в меню подтверждения удаления группы
            {
              final buttonCancel = find.text("Отмена");
              expect(buttonCancel, findsOne, reason: "Нет надписи 'Отмена' в окне подтверждения удаления группы");

              await tapButton(buttonCancel);
              expect(find.byIcon(iconButtonModeDiceGroup), findsNWidgets(numberDiceGroup), reason: "Группа удалилась после 'Отмена'");
              expect(find.text("Название 2"), findsNWidgets(2), reason: "Что то странное после 'Отмена'");
              expect(buttonDeleteDiceGroup, findsOne, reason: "Окошко с выбором действий для группы пропало после кнопки 'Отмена'");
            }

            await tapButton(buttonDeleteDiceGroup);

            /// тестирование кнопки 'Удалить группу' в меню подтверждения удаления группы
            {
              final buttonDelete = find.text("Удалить группу");
              expect(buttonDelete, findsOne, reason: "Нет надписи 'Удалить группу' в окне подтверждения удаления группы");

              await tapButton(buttonDelete);
              numberDiceGroup--;
              expect(find.byIcon(iconButtonModeDiceGroup), findsNWidgets(numberDiceGroup), reason: "Группа не удалилась после 'Удалить группу'");
              expect(find.text("Название 2"), findsNWidgets(1), reason: "Удалилась не та группа после 'Удалить группу'");
              expect(buttonDeleteDiceGroup, findsNothing, reason: "Окошко с выбором действий для группы осталось после кнопки 'Удалить группу'");
            }
          }

          await tapButton(find.byIcon(iconButtonModeDiceGroup).first);
          await tapButton(find.byIcon(iconButtonDeleteDiceGroup));
          await tapButton(find.text("Удалить группу"));
          numberDiceGroup--;
          expect(find.byIcon(iconButtonModeDiceGroup), findsOne, reason: "Не удалилась добавленная группа");
        }

        /// тестирование кнопки развернуть и свернуть группу
        {
          final oneDiceGroup = find.text("Название 2");
          await tapButton(oneDiceGroup);
          // TODO я не знаю как это протестировать. Виджеты не пропадают при сворачивании их всё ещё можно find даже в закрытом состояние
          expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Группа не развернулась или iconButtonModeDice не отображаются"); // FIXME этот тест проходит всегад

          await tapButton(oneDiceGroup);
          //expect(find.byIcon(iconButtonModeDice), findsNothing, reason: "Группа не свернулась");      // FIXME этот тест не проходит никогда
        }

        ///тестирование активирования и деактивирования всей группы
        {
          final buttonActive = find.byIcon(iconRadioButtonChecked);
          final buttonDeactive = find.byIcon(iconRadioButtonUnchecked);
          expect(buttonDeactive, findsNWidgets(numberDiceGroup + numberDice), reason: "На экране не 4 кнопки активации");

          await tapButton(buttonDeactive.first);
          expect(buttonActive, findsNWidgets(numberDiceGroup + numberDice), reason: "Не активировалась группа");

          await tapButton(buttonActive.first);
          expect(buttonDeactive, findsNWidgets(numberDiceGroup + numberDice), reason: "Не деактивировалась группа");
        }
      }

      ///
      ///
      ///
      ///
      ///
      ///
      ///
      ///

      /// тестирование взаимодействия с кубиком
      {
        final buttonModeDice = find.byIcon(iconButtonModeDice);

        /// тестирование кнопки редактирования кубика
        {
          await tapButton(buttonModeDice.first);

          final buttonEditDice = find.byIcon(iconButtonEditDice);
          expect(buttonEditDice, findsOne, reason: "Не отображается иконка редактирования кубика");

          await tapButton(buttonEditDice);

          /// тестирование окна редактирования кубика
          {
            expect(find.text("Редактирование игральной кости"), findsOne, reason: "Нет заголовка окна редактирования кубика");
            expect(find.text("Количество граней:"), findsOne, reason: "Нет подписи к полю 'количество граней' в окне редактирования кубика");
            expect(find.text("Нажмите на грань, чтобы выбрать для неё изображение"), findsOne, reason: "Нет инструкции к выбору изображения на грань");
            final fieldInputFaceNumber = find.byType(TextField);
            expect(fieldInputFaceNumber, findsOne, reason: "Нет поля изменения количества граней");
            expect(find.byType(ElevatedButton), findsNWidgets(2), reason: "Нет кнопок в нижней части экрана");

            /// тестирование изменения количества граней кубика
            {
              await tester.enterText(fieldInputFaceNumber, "7");
              await tester.pumpAndSettle();
              expect(find.text("7"), findsNWidgets(2), reason: "Количество граней не ввелось в поле"); // 1 из поля ввода, 1 из квадратика в редактирование граней
            }

            /// тестирование кнопки 'Отмена' в окне окне редактирования кубика
            {
              final buttonCancel = find.text("Отмена");
              expect(buttonCancel, findsOne, reason: "Нет надписи 'Отмена' в окне редактирования кубика");

              await tapButton(buttonCancel);
              expect(find.text("Редактирование игральной кости"), findsNothing, reason: "Не пропало окно редактирования кубика после 'Отмена'");
              expect(find.text("7"), findsNothing, reason: "Количество граней изменилось при 'Отмена'");
              expect(buttonEditDice, findsOne, reason: "Окно с выбором действий для кубика пропало после кнопки 'Отмена'");
            }

            await tapButton(buttonEditDice);

            /// тестирование кнопки 'Сохранить' в окне окне редактирования кубика
            {
              await tester.enterText(fieldInputFaceNumber, "8");
              await tester.pumpAndSettle();
              final buttonSave = find.text("Сохранить");
              expect(buttonSave, findsOne, reason: "Нет надписи 'Сохранить' в окне редактирования кубика");

              await tapButton(buttonSave);
              expect(find.text("Редактирование игральной кости"), findsNothing, reason: "Не пропало окно редактирования кубика после 'Сохранить'");
              expect(find.text("8"), findsOne, reason: "Количество граней не изменилось после 'Сохранить'");
              expect(buttonEditDice, findsNothing, reason: "Окошко с выбором действий для кубика осталось после кнопки 'Сохранить'");
            }
          }
        }

        /// тестирование кнопки дублирования кубика
        {
          await tapButton(buttonModeDice.first);
          final buttonDuplicateDice = find.byIcon(iconButtonDuplicateDice);
          expect(buttonDuplicateDice, findsOne, reason: "Не отображается иконка дублирования кубика");

          await tapButton(buttonDuplicateDice);
          numberDice++;
          expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Кубик не дублировался");
          expect(find.text("8"), findsNWidgets(2), reason: "Дублировался другой кубик");
        }

        /// тестирование кнопки удаления кубика
        {
          await tapButton(buttonModeDice.first);
          final buttonDeleteDice = find.byIcon(iconButtonDeleteDice);
          expect(buttonDeleteDice, findsOne, reason: "Не отображается иконка удаления кубика");

          await tapButton(buttonDeleteDice);

          expect(find.text("Удалить игральную кость?"), findsOne, reason: "Не отображается заголовок окна подтверждения удаления кубика");
          expect(find.text("Игральная кость с 8 гранями будет удалёна."), findsOne, reason: "Не отображается основной текст окна подтверждения удаления кубика");
          expect(find.byType(ElevatedButton), findsNWidgets(2), reason: "Нет кнопок в нижней части экрана подтверждения удаления кубика");

          /// тестирование кнопки 'Отмена' в меню подтверждения удаления кубика
          {
            final buttonCancel = find.text("Отмена");
            expect(buttonCancel, findsOne, reason: "Нет надписи 'Отмена' в окне подтверждения удаления кубика");

            await tapButton(buttonCancel);
            expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Кубик удалился после 'Отмена'");
            expect(buttonDeleteDice, findsOne, reason: "Окошко с выбором действий для кубика пропало после кнопки 'Отмена'");
          }

          await tapButton(buttonDeleteDice);

          /// тестирование кнопки 'Удалить игральную кость' в меню подтверждения удаления кубика
          {
            final buttonDelete = find.text("Удалить игральную кость");
            expect(buttonDelete, findsOne, reason: "Нет надписи 'Удалить игральную кость' в окне подтверждения удаления кубика");

            await tapButton(buttonDelete);
            numberDice--;
            expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Кубик не удалился после 'Удалить кубик'");
            expect(buttonDeleteDice, findsNothing, reason: "Окошко с выбором действий для кубика осталось после кнопки 'Удалить кубик'");
          }

          await tapButton(find.byIcon(iconButtonModeDice).at(1));
          await tapButton(find.byIcon(iconButtonDeleteDice));
          await tapButton(find.text("Удалить игральную кость"));
          numberDice--;
          expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Не удалился кубик из центра");
        }

        /// тестирование добавления нового кубика
        {
          await tapButton(find.byIcon(iconButtonAddDice).last);
          numberDice++;
          expect(find.byIcon(iconButtonModeDice), findsNWidgets(numberDice), reason: "Не добавился новый кубик");
        }

        /// тестирование активирования и деактивирования кубика
        {
          final buttonActive = find.byIcon(iconRadioButtonChecked);
          final buttonDeactive = find.byIcon(iconRadioButtonUnchecked);
          expect(buttonDeactive, findsNWidgets(numberDiceGroup + numberDice), reason: "В единственной группе не 4 кубика");

          await tapButton(buttonDeactive.last);
          expect(buttonActive, findsNWidgets(numberDiceGroup + 1), reason: "Не появились активированные кубики 2"); // +1 за группу
          expect(buttonDeactive, findsNWidgets(numberDice - 1), reason: "Не исчезли деактивированные кубики 3"); // -1 за группу

          await tapButton(buttonDeactive.last);
          expect(buttonActive, findsNWidgets(numberDiceGroup + 2), reason: "Не появились активированные кубики 3"); // +1 за группу
          expect(buttonDeactive, findsNWidgets(numberDice - 2), reason: "Не исчезли деактивированные кубики 2"); // -1 за группу

          await tapButton(buttonActive.first);
          expect(buttonDeactive, findsNWidgets(numberDiceGroup + numberDice), reason: "Не появились деактивированные кубики 5"); // +1 за группу
          expect(buttonActive, findsNothing, reason: "Не пропали активированные кубики 0");

          await tapButton(buttonDeactive.first);
        }

        /// тестирование бросков кубиков
        {
          await tester.tap(find.byIcon(iconButtonDrawer).first, warnIfMissed: false);
          await tester.pumpAndSettle();

          expect(find.byType(SizedBox), findsNWidgets(5), reason: "На экране не 3 кубика"); // два SizedBox от кнопок выбора кубиков

          expect(find.text("8"), findsNWidgets(1), reason: "На экране не 1 кубика с 8 гранями");
          expect(find.text("6"), findsNWidgets(2), reason: "На экране не 2 кубика с 6 гранями");

          await tapButton(find.text("Бросить все игральные кости"));
          expect(find.byType(SizedBox), findsNWidgets(5), reason: "После броска количество кубиков уменьшилось"); // два SizedBox от кнопок выбора кубиков

          await tester.pumpAndSettle(const Duration(microseconds: 500));
        }

        /// тестирование редактирования граней кубика
        {
          await tapButton(find.byIcon(iconButtonDrawer).first);

          await tapButton(find.byIcon(iconButtonModeDice).at(1));
          await tapButton(find.byIcon(iconButtonEditDice));
          await tapButton(find.text("1").last);

          // await Process.run(     // это не работает, но должно было нажимать стрелочку назад
          //   'adb',
          //   <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
          //   runInShell: true,
          // );
        }
      }
    }
  });
}
