///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается в форме элемента справочника СертификатыКлючейЭлектроннойПодписиИШифрования и в других местах,
// где создаются или обновляются сертификаты, например в форме ВыборСертификатаДляПодписанияИлиРасшифровки.
// Допускается вызов исключения, если требуется остановить действие и что-то сообщить пользователю -
// например, при попытке создать элемент - копию сертификата, доступ к которому ограничен.
//
// Параметры:
//  Ссылка     - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - пустая для нового элемента.
//
//  Сертификат - СертификатКриптографии - сертификат, для которого создается или обновляется элемент справочника.
//
//  ПараметрыРеквизитов - ТаблицаЗначений:
//               * ИмяРеквизита       - Строка - имя реквизита, для которого можно уточнить параметры.
//               * ТолькоПросмотр     - Булево - если установить Истина, редактирование будет запрещено.
//               * ПроверкаЗаполнения - Булево - если установить Истина, заполнение будет проверяться.
//               * Видимость          - Булево - если установить Истина, реквизит станет невидимым.
//               * ЗначениеЗаполнения - Произвольный - начальное значение реквизита нового объекта.
//                                    - Неопределено - заполнение не требуется.
//
Процедура ПередНачаломРедактированияСертификатаКлюча(Ссылка, Сертификат, ПараметрыРеквизитов) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании на сервере форм ПодписаниеДанных, РасшифровкаДанных.
// Используется для дополнительных действий, которые требуют серверного вызова, чтобы не
// вызывать сервер лишний раз.
//
// Параметры:
//  Операция          - Строка - строка Подписание или Расшифровка.
//
//  ВходныеПараметры  - Произвольный - значение свойства ПараметрыДополнительныхДействий
//                      параметра ОписаниеДанных методов Подписать, Расшифровать общего
//                      модуля ЭлектроннаяПодписьКлиент.
//                      
//  ВыходныеПараметры - Произвольный - произвольные возвращаемые данные, которые
//                      будут помещены в одноименную процедуру в общем модуле.
//                      ЭлектроннаяПодписьКлиентПереопределяемый после создания формы
//                      на сервере, но до ее открытия.
//
Процедура ПередНачаломОперации(Операция, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается для расширения состава выполняемых проверок.
//
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
// 
//  ДополнительныеПроверки - ТаблицаЗначений:
//    * Имя           - Строка - имя дополнительной проверки, например, АвторизацияВТакском.
//    * Представление - Строка - пользовательское имя проверки, например, "Авторизация на сервере Такском".
//    * Подсказка     - Строка - подсказка, которая будет показана пользователю при нажатии на знак вопроса.
//
//  ПараметрыДополнительныхПроверок - Произвольный - значение одноименного параметра, указанное
//    в процедуре ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент.
//
//  СтандартныеПроверки - Булево - если установить Ложь, тогда все стандартные проверки будут
//    пропущены и скрыты. Скрытые проверки не попадают в свойство Результат
//    процедуры ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент, кроме того
//    параметр МенеджерКриптографии не будет определен в процедурах ПриДополнительнойПроверкеСертификата
//    общих модулей ЭлектроннаяПодписьПереопределяемый и ЭлектроннаяПодписьКлиентПереопределяемый.
//
//  ВводитьПароль - Булево - если установить Ложь, тогда ввод пароля для закрытой части ключа сертификата будет скрыт.
//    Не учитывается, если параметр СтандартныеПроверки не установлен в Ложь.
//
Процедура ПриСозданииФормыПроверкаСертификата(Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль = Истина) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из формы ПроверкаСертификата, если при создании формы были добавлены дополнительные проверки.
//
// Параметры:
//  Параметры - Структура:
//   * Сертификат           - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
//   * Проверка             - Строка - имя проверки, добавленное в процедуре ПриСозданииФормыПроверкаСертификата
//                              общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * МенеджерКриптографии - МенеджерКриптографии - подготовленный менеджер криптографии для
//                              выполнения проверки.
//                         - Неопределено - если стандартные проверки отключены в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * ОписаниеОшибки       - Строка - возвращаемое значение. Описание ошибки, полученной при выполнении проверки.
//                              Это описание сможет увидеть пользователь при нажатии на картинку результата.
//   * ЭтоПредупреждение    - Булево - возвращаемое значение. Вид картинки Ошибка/Предупреждение,
//                            начальное значение - Ложь.
//   * Пароль               - Строка - пароль, введенный пользователем.
//                         - Неопределено - если свойство ВводитьПароль установлено в Ложь в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * РезультатыПроверок   - Структура:
//      * Ключ     - Строка - имя дополнительной проверки, которая уже выполнена.
//      * Значение - Неопределено - дополнительная проверка не выполнялась (ОписаниеОшибки осталось Неопределено).
//                 - Булево - результат выполнения дополнительной проверки.
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти