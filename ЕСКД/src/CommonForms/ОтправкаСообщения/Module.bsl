///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИсторияПолучателей;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначения.УстановитьУсловноеОформлениеСпискаВыбора(ЭтотОбъект, "ПочтовыйАдресПолучателейВариантОтправки", "ПочтовыеАдресаПолучателей.ВариантОтправки");
	
	РезультатУспехЦвет = ЦветаСтиля.РезультатУспехЦвет;
	
	ВложенияДляПисьма = Новый Структура;
	
	Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Или ТипЗнч(Параметры.Вложения) = Тип("Массив") Тогда
		Для Каждого Вложение Из Параметры.Вложения Цикл
			ОпределитьНазначениеВложенияПисьма(Вложение, ВложенияДляПисьма);
		КонецЦикла;
	КонецЕсли;
	
	ТемаПисьма = Параметры.Тема;
	ТелоПисьма.УстановитьHTML(ТекстВHTML(Параметры.Текст), ВложенияДляПисьма);
	АдресОтвета = Параметры.АдресОтвета;
	Предмет = Параметры.Предмет;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Отправитель) Тогда
		// Учетная запись не передана - выбираем первую доступную.
		ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
		Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			Возврат;
		КонецЕсли;
		
		УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка;
		
	ИначеЕсли ТипЗнч(Параметры.Отправитель) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		УчетнаяЗапись = Параметры.Отправитель;
	ИначеЕсли ТипЗнч(Параметры.Отправитель) = Тип("СписокЗначений") Тогда
		НаборУчетныхЗаписей = Параметры.Отправитель;
		
		Если НаборУчетныхЗаписей.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны учетные записи для отправки сообщения, обратитесь к администратору системы.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементУчетнаяЗапись Из НаборУчетныхЗаписей Цикл
			Элементы.УчетнаяЗапись.СписокВыбора.Добавить(
										ЭлементУчетнаяЗапись.Значение,
										ЭлементУчетнаяЗапись.Представление);
			Если ЭлементУчетнаяЗапись.Значение.ИспользоватьДляПолучения Тогда
				АдресаОтветаПоУчетнымЗаписям.Добавить(ЭлементУчетнаяЗапись.Значение,
														ПолучитьПочтовыйАдресПоУчетнойЗаписи(ЭлементУчетнаяЗапись.Значение));
			КонецЕсли;
		КонецЦикла;
		
		Элементы.УчетнаяЗапись.СписокВыбора.СортироватьПоПредставлению();
		УчетнаяЗапись = НаборУчетныхЗаписей[0].Значение;
		
		// Для переданного списка учетных записей выбираем их из списка выбора.
		Элементы.УчетнаяЗапись.КнопкаВыпадающегоСписка = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Получатель) = Тип("СписокЗначений") Тогда
		
		Для Каждого ЭлементПочтовыйАдрес Из Параметры.Получатель Цикл
			НовыйПолучатель = ПочтовыеАдресаПолучателей.Добавить();
			НовыйПолучатель.ВариантОтправки = "Кому";
			Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) Тогда
				НовыйПолучатель.Представление = ЭлементПочтовыйАдрес.Представление
										+ " <"
										+ ЭлементПочтовыйАдрес.Значение
										+ ">"
			Иначе
				НовыйПолучатель.Представление = ЭлементПочтовыйАдрес.Значение;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("Строка") Тогда
		НовыйПолучатель                 = ПочтовыеАдресаПолучателей.Добавить();
		НовыйПолучатель.ВариантОтправки = "Кому";
		НовыйПолучатель.Представление   = Параметры.Получатель;
	ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("Массив") Тогда
		Для Каждого СтруктураПолучателя Из Параметры.Получатель Цикл
			ЕстьСвойствоВыбран = СтруктураПолучателя.Свойство("Выбран");
			МассивАдресов      = СтрРазделить(СтруктураПолучателя.Адрес, ";");
			Для Каждого Адрес Из МассивАдресов Цикл
				Если ПустаяСтрока(Адрес) Тогда
					Продолжить;
				КонецЕсли;
				Если (ЕстьСвойствоВыбран И СтруктураПолучателя.Выбран) ИЛИ (НЕ ЕстьСвойствоВыбран) Тогда
					НовыйПолучатель                 = ПочтовыеАдресаПолучателей.Добавить();
					НовыйПолучатель.ВариантОтправки = "Кому";
					НовыйПолучатель.Представление   = СтруктураПолучателя.Представление + " <" + СокрЛП(Адрес) + ">";
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Получатель) = Тип("Массив") Тогда
		Если ТипЗнч(Параметры.Получатель) = Тип("Строка") Тогда
			ЗаполнитьТаблицуПолучателейИзСтроки(Параметры.Получатель);
		ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("СписокЗначений") Тогда
			ПолучателиСообщения = (Параметры.Получатель);
		ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("Массив") Тогда
			ЗаполнитьТаблицуПолучателейИзМассиваСтруктур(Параметры.Получатель);
		КонецЕсли;
		
		ОписаниеПолучателяВоВременномХранилище = ПоместитьВоВременноеХранилище(Параметры.Получатель, УникальныйИдентификатор);
	Иначе
		ОписаниеПолучателяВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
	КонецЕсли;
	
	Если ПочтовыеАдресаПолучателей.Количество() = 0 Тогда
		НоваяСтрока                 = ПочтовыеАдресаПолучателей.Добавить();
		НоваяСтрока.ВариантОтправки = "Кому";
		НоваяСтрока.Представление   = "";
	КонецЕсли;
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма", "СписокАдресовОтвета");
	
	Если СписокАдресовОтвета <> Неопределено И СписокАдресовОтвета.Количество() > 0 Тогда
		Для Каждого ЭлементаАдресОтвета Из СписокАдресовОтвета Цикл
			Элементы.АдресОтвета.СписокВыбора.Добавить(ЭлементаАдресОтвета.Значение, ЭлементаАдресОтвета.Представление);
		КонецЦикла;
		
		Элементы.АдресОтвета.КнопкаВыпадающегоСписка = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	Иначе
		Если УчетнаяЗапись.ИспользоватьДляПолучения Тогда
			// Устанавливаем почтовый адрес по умолчанию.
			Если ЗначениеЗаполнено(УчетнаяЗапись.ИмяПользователя) Тогда 
				АдресОтвета = УчетнаяЗапись.ИмяПользователя + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">";
			Иначе
				АдресОтвета = УчетнаяЗапись.АдресЭлектроннойПочты;
			КонецЕсли;
		КонецЕсли;
		
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ШаблоныСообщений
	
	Элементы.ФормаСформироватьПоШаблону.Видимость = Ложь;
	Элементы.ФормаСохранитьКакШаблон.Видимость    = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений")Тогда
		МодульШаблоныСообщенийСлужебный = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщенийСлужебный");
		
		Если МодульШаблоныСообщенийСлужебный.ИспользуютсяШаблоныСообщений() Тогда
			Элементы.ФормаСформироватьПоШаблону.Видимость = МодульШаблоныСообщенийСлужебный.ЕстьДоступныеШаблоны("Письмо", Предмет);
			Элементы.ФормаСохранитьКакШаблон.Видимость    = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.ШаблоныСообщений
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Вложение2.Видимость = Ложь;
		Элементы.ОсновнаяГруппаТелаПисьма.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.ТемаПисьма.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗагрузитьВложенияИзФайлов();
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Не ТребуетсяПодтверждениеЗакрытияФормы Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПоказатьВопросПередЗакрытиемФормы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если Не ЗавершениеРаботы Тогда
		АдресаВложений = Новый Массив;
		Для Каждого Вложение Из Вложения Цикл
			АдресаВложений.Добавить(Вложение.АдресВоВременномХранилище);
		КонецЦикла;
		ОчиститьВложения(АдресаВложений);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Подставляет адрес ответа, если флаг автоматической подстановки ответа установлен.
//
&НаКлиенте
Процедура УчетнаяЗаписьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ПустаяСтрока(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
			АдресОтвета = АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение).Представление;
		Иначе
			АдресОтвета = ПолучитьПочтовыйАдресПоУчетнойЗаписи(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПризнакМодифицированностиФормы(Элемент)
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПочтовыеАдресаПолучателей

&НаКлиенте
Процедура ПочтовыйАдресаПолучателейПередУдалением(Элемент, Отказ)
	
	Если ПочтовыеАдресаПолучателей.Количество() = 1 Тогда
		Отказ = Истина;
		ПочтовыеАдресаПолучателей[0].Представление = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйАдресаПолучателейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ВариантОтправки = "Кому";
		Элемент.ТекущийЭлемент                = Элементы.ПочтовыйАдресПолучателейПредставление;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйАдресПолучателейПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ПолучателиСообщения.Количество() = 0 Тогда
		ДанныеВыбора = ПохожиеПолучателиИзИстории(Текст);
	Иначе
		ДанныеВыбора = ПохожиеПолучателиИзСпискаПереданных(Текст);
	КонецЕсли;
	
	Если ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйАдресаПолучателейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = ПочтовыйАдресИзПредставления(ДанныеСтроки.Представление);
	
	Если ПустаяСтрока(Адрес) Тогда
		Адрес = ДанныеСтроки.Представление;
	КонецЕсли;
	
	Если ПустаяСтрока(Адрес) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Адрес, Истина) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите корректный адрес электронной почты.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Дубли = Новый Соответствие;
	Для каждого ПолучательПисьма Из ПочтовыеАдресаПолучателей Цикл
		АдресПочты = ПочтовыйАдресИзПредставления(ПолучательПисьма.Представление);
		Если Дубли[ВРег(АдресПочты)] = Неопределено Тогда
			Дубли.Вставить(ВРег(АдресПочты), Истина);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Такой адрес электронной почты уже есть в списке.'"));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

// Удаляет вложение из списка, а так же вызывает функцию
// обновления таблицы представления вложений.
//
&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	НаименованиеВложения = Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя];
	
	Для Каждого Вложение Из Вложения Цикл
		Если Вложение.Представление = НаименованиеВложения Тогда
			Вложения.Удалить(Вложение);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	КоллекцияЗначений = ПараметрыПеретаскивания.Значение;
	Если ТипЗнч(КоллекцияЗначений) <> Тип("Массив") Тогда
		КоллекцияЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыПеретаскивания.Значение);
	КонецЕсли;
	
	ЗагружаемыеФайлы = Новый Массив;
	Для Каждого Файл Из КоллекцияЗначений Цикл
		Если ТипЗнч(Файл) = Тип("СсылкаНаФайл") Тогда
			ЗагружаемыеФайлы.Добавить(Файл);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ЗагружаемыеФайлы) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗагрузкеВложений", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Интерактивно = Ложь;
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(ОписаниеОповещения, ПараметрыЗагрузки, ЗагружаемыеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	АдресОтвета = ПолучитьПриведенныйПочтовыйАдресВФормате(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	СохранитьАдресОтвета(АдресОтвета, Ложь);
	
	Для Каждого ЭлементаАдресОтвета Из Элементы.АдресОтвета.СписокВыбора Цикл
		Если ЭлементаАдресОтвета.Значение = АдресОтвета
		   И ЭлементаАдресОтвета.Представление = АдресОтвета Тогда
			Элементы.АдресОтвета.СписокВыбора.Удалить(ЭлементаАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	АдресОтвета = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмо()
	
	ОчиститьСообщения();
	ЕстьОшибочныеПолучатели = Ложь;
	СообщениеОтправлено = Ложь;
	Попытка
		СообщениеОтправлено = ОтправитьПочтовоеСообщение(ЕстьОшибочныеПолучатели);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаголовокОшибки = НСтр("ru = 'Письмо не отправлено'");
		РаботаСПочтовымиСообщениямиКлиент.СообщитьОбОшибкеПодключения(УчетнаяЗапись, ЗаголовокОшибки, ТекстОшибки);
		Возврат;
	КонецПопытки;
	
	Если ПоляЗаполненыКорректно() И СообщениеОтправлено Тогда
		СохранитьАдресОтвета(АдресОтвета);
		ТребуетсяПодтверждениеЗакрытияФормы = Ложь;
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Сообщение отправлено:'"), ,
			?(ПустаяСтрока(ТемаПисьма), НСтр("ru = '<Без темы>'"), ТемаПисьма), БиблиотекаКартинок.Информация32);
		
		Если ЕстьОшибочныеПолучатели Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Письмо отправлено не всем получателям.'"));
		Иначе
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоляЗаполненыКорректно()
	Результат = Истина;
	
	Если ПочтовыеАдресаПолучателей.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Заполните получателя письма'"), , "ПочтовыеАдресаПолучателей");
		Результат = Ложь;
	КонецЕсли;
	Для каждого ПолучательПочты Из ПочтовыеАдресаПолучателей Цикл
		Адрес = ПочтовыйАдресИзПредставления(ПолучательПочты.Представление);
		Если ПустаяСтрока(Адрес) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Заполните получателя письма'"),, "ПочтовыеАдресаПолучателей[" + Формат(ПочтовыеАдресаПолучателей.Индекс(ПолучательПочты), "ЧГ=0") + "].Представление");
			Результат = Ложь;
		ИначеЕсли Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Адрес, Ложь) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Неверный адрес электронной почты'"),, "ПочтовыеАдресаПолучателей[" + Формат(ПочтовыеАдресаПолучателей.Индекс(ПолучательПочты), "ЧГ=0") + "].Представление");
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПриложитьФайлВыполнить()
	
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

// СтандартныеПодсистемы.ШаблоныСообщений

&НаКлиенте
Процедура СформироватьПоШаблону(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		МодульШаблоныСообщенийКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ШаблоныСообщенийКлиент");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект);
		ПредметСообщения = ?(ЗначениеЗаполнено(Предмет), Предмет, "Общий");
		МодульШаблоныСообщенийКлиент.ПодготовитьСообщениеПоШаблону(ПредметСообщения, "Письмо", Оповещение);
	КонецЕсли
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОтправитьПочтовоеСообщение(ЕстьОшибочныеПолучатели)
	
	ПараметрыПисьма = СформироватьПараметрыПисьма();
	Если ПараметрыПисьма = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Письмо = РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
	РезультатОтправки = РаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
	РаботаСПочтовымиСообщениямиПереопределяемый.ПослеОтправкиПисьма(ПараметрыПисьма);
	
	ДобавитьПолучателейВИсторию(ПараметрыПисьма.Кому);
	
	ОшибочныеПолучатели = РезультатОтправки.ОшибочныеПолучатели;
	Если ОшибочныеПолучатели.Количество() > 0 Тогда
		Для Каждого ОшибочныйПолучатель Из ОшибочныеПолучатели Цикл
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1: %2'"),
				ОшибочныйПолучатель.Ключ, ОшибочныйПолучатель.Значение);
				
			Поле = "ПочтовыеАдресаПолучателей";
			Для Каждого АдресПолучателя Из ПочтовыеАдресаПолучателей Цикл
				Если СтрНайти(АдресПолучателя.Представление, ОшибочныйПолучатель.Ключ) > 0 Тогда
					Поле = Поле + "[" + XMLСтрока(ПочтовыеАдресаПолучателей.Индекс(АдресПолучателя)) + "].Представление";
					Прервать;
				КонецЕсли;
			КонецЦикла;
				
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле);
		КонецЦикла;
		
		ЕстьОшибочныеПолучатели = Истина;
		Возврат ПочтовыеАдресаПолучателей.Количество() > ОшибочныеПолучатели.Количество();
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПочтовыйАдресПоУчетнойЗаписи(Знач УчетнаяЗапись)
	
	Возврат СокрЛП(УчетнаяЗапись.ИмяПользователя)
			+ ? (ПустаяСтрока(СокрЛП(УчетнаяЗапись.ИмяПользователя)),
					УчетнаяЗапись.АдресЭлектроннойПочты,
					" <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">");
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВложение()
	
	ВыбранноеВложение = ВыбранноеВложение();
	Если ВыбранноеВложение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	Если СтрЗаканчиваетсяНа(ВыбранноеВложение.Представление, ".mxl") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьОткрытиеФайлаMXLПослеСозданияКаталога", ЭтотОбъект, ВыбранноеВложение);
		ФайловаяСистемаКлиент.СоздатьВременныйКаталог(ОписаниеОповещения);
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	ФайловаяСистемаКлиент.ОткрытьФайл(ВыбранноеВложение.АдресВоВременномХранилище, , ВыбранноеВложение.Представление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОткрытиеФайлаMXLПослеСозданияКаталога(ИмяВременногоКаталога, ВыбранноеВложение) Экспорт
	
#Если Не ВебКлиент Тогда
	ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременногоКаталога) + ВыбранноеВложение.Представление;
	ТабличныйДокумент = ПолучитьТабличныйДокументПоДвоичнымДанным(ВыбранноеВложение.АдресВоВременномХранилище);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВыбранноеВложение.АдресВоВременномХранилище); // ДвоичныеДанные
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	Файл = Новый Файл(ИмяВременногоФайла);
	Файл.УстановитьТолькоЧтение(Истина);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяДокумента", ВыбранноеВложение.Представление);
	ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	ПараметрыОткрытия.Вставить("ПутьКФайлу", ИмяВременногоФайла);
	
	ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранноеВложение()
	
	Результат = Неопределено;
	Если Элементы.Вложения.ТекущиеДанные <> Неопределено Тогда
		НаименованиеВложения = Элементы.Вложения.ТекущиеДанные[Элементы.Вложения.ТекущийЭлемент.Имя];
		Для Каждого Вложение Из Вложения Цикл
			Если Вложение.Представление = НаименованиеВложения Тогда
				Результат = Новый Структура("Представление, АдресВоВременномХранилище");
				ЗаполнитьЗначенияСвойств(Результат, Вложение);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТабличныйДокументПоДвоичнымДанным(Знач ДвоичныеДанные)
	
	Если ТипЗнч(ДвоичныеДанные) = Тип("Строка") Тогда
		// Передан адрес двоичных данных во временном хранилище.
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДвоичныеДанные); // ДвоичныеДанные
	КонецЕсли;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение табличного документа'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьФайлВоВложения()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(ОписаниеОповещения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ДобавитьФайлыВСписок(ПомещенныеФайлы);
	ОбновитьПредставлениеВложений();
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписок(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		Файл = Новый Файл(ОписаниеФайла.Имя);
		Вложение = Вложения.Добавить();
		Вложение.Представление = Файл.Имя;
		Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение), УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеВложений()
	
	ПредставлениеВложений.Очистить();
	
	Индекс = 0;
	
	Для Каждого Вложение Из Вложения Цикл
		Если Индекс = 0 Тогда
			СтрокаПредставления = ПредставлениеВложений.Добавить();
		КонецЕсли;
		
		СтрокаПредставления["Вложение" + Формат(Индекс + 1, "ЧГ=0")] = Вложение.Представление;
		Если Элементы.Вложение2.Видимость Тогда // Для мобильного клиента.
			Индекс = Индекс + 1;
			Если Индекс = 2 Тогда 
				Индекс = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет возможность отправления письма и если
// это возможно - формирует параметры отправки.
//
&НаСервере
Функция СформироватьПараметрыПисьма()
	
	ПараметрыПисьма = Новый Структура;
	Кому = Новый Массив;
	Копии = Новый Массив;
	СкрытыеКопии = Новый Массив;
	
	Для каждого Получатель Из ПочтовыеАдресаПолучателей Цикл
		ПочтаПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Получатель.Представление);
		Для каждого ПочтаПолучателя Из ПочтаПолучателей Цикл
			Если Получатель.ВариантОтправки = "СкрытаяКопия" Тогда
				СкрытыеКопии.Добавить(Новый Структура("Адрес, Представление", ПочтаПолучателя.Адрес, ПочтаПолучателя.Псевдоним));
			ИначеЕсли Получатель.ВариантОтправки = "Копия" Тогда
				Копии.Добавить(Новый Структура("Адрес, Представление", ПочтаПолучателя.Адрес, ПочтаПолучателя.Псевдоним));
			Иначе
				Кому.Добавить(Новый Структура("Адрес, Представление", ПочтаПолучателя.Адрес, ПочтаПолучателя.Псевдоним));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Кому.Количество() > 0 Тогда
		ПараметрыПисьма.Вставить("Кому", Кому);
	КонецЕсли;
	Если Копии.Количество() > 0 Тогда
		ПараметрыПисьма.Вставить("Копии", Копии);
	КонецЕсли;
	Если СкрытыеКопии.Количество() > 0 Тогда
		ПараметрыПисьма.Вставить("СкрытыеКопии", СкрытыеКопии);
	КонецЕсли;
	
	СписокПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(АдресОтвета);
	Кому = Новый Массив;
	Для Каждого Получатель Из СписокПолучателей Цикл
		Если Не ПустаяСтрока(Получатель.ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				Получатель.ОписаниеОшибки, , "АдресОтвета");
			Возврат Неопределено;
		КонецЕсли;
		Кому.Добавить(Новый Структура("Адрес, Представление", Получатель.Адрес, Получатель.Псевдоним));
	КонецЦикла;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		ПараметрыПисьма.Вставить("АдресОтвета", АдресОтвета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТемаПисьма) Тогда
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеПолучателяВоВременномХранилище) Тогда
		ПараметрыПисьма.Вставить("ПолучателиСообщения", ПолучитьИзВременногоХранилища(ОписаниеПолучателяВоВременномХранилище));
	КонецЕсли;
	
	ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	ПараметрыПисьма.Вставить("Вложения", Вложения());
	
	Возврат ПараметрыПисьма;
	
КонецФункции

&НаСервере
Функция ТекстВHTML(Текст)
	
	Если СтрНайти(НРег(Текст), "</html>", НаправлениеПоиска.СКонца) > 0 Тогда
		Возврат Текст;
	КонецЕсли;
	
	ДокументHTML = Новый ДокументHTML;
	
	ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
	ДокументHTML.Тело = ЭлементТело;
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		
		ЭлементБлок = ДокументHTML.СоздатьЭлемент("p");
		ЭлементТело.ДобавитьДочерний(ЭлементБлок);
		
		ЭлементТекст = ДокументHTML.СоздатьТекстовыйУзел(Строка);
		ЭлементБлок.ДобавитьДочерний(ЭлементТекст);
	КонецЦикла;
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML, ЗаписьHTML);
	Результат = ЗаписьHTML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция Вложения()
	
	Результат = Новый Массив;
	Для Каждого Вложение Из Вложения Цикл
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", Вложение.Представление);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", Вложение.АдресВоВременномХранилище);
		ОписаниеВложения.Вставить("Кодировка", Вложение.Кодировка);
		ОписаниеВложения.Вставить("Идентификатор", Вложение.Идентификатор);
		Результат.Добавить(ОписаниеВложения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОпределитьНазначениеВложенияПисьма(Вложение, ВложенияДляПисьма)
	
	Если Вложение.Свойство("Идентификатор") И ЗначениеЗаполнено(Вложение.Идентификатор) Тогда
		КартинкаВложение = Новый Картинка(ПолучитьИзВременногоХранилища(Вложение.АдресВоВременномХранилище));
		ВложенияДляПисьма.Вставить(Вложение.Представление, КартинкаВложение);
	Иначе
		ОписаниеВложения = Вложения.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеВложения, Вложение);
		Если Не ПустаяСтрока(ОписаниеВложения.АдресВоВременномХранилище) Тогда
			ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
			ПолучитьИзВременногоХранилища(ОписаниеВложения.АдресВоВременномХранилище), УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьАдресОтвета(Знач АдресОтвета, Знач ДобавлятьАдресВСписок = Истина)
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета");
	
	Если СписокАдресовОтвета = Неопределено Тогда
		СписокАдресовОтвета = Новый СписокЗначений();
	КонецЕсли;
	
	Для Каждого ЭлементАдресОтвета Из СписокАдресовОтвета Цикл
		Если ЭлементАдресОтвета.Значение = АдресОтвета
		   И ЭлементАдресОтвета.Представление = АдресОтвета Тогда
			СписокАдресовОтвета.Удалить(ЭлементАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавлятьАдресВСписок
	   И ЗначениеЗаполнено(АдресОтвета) Тогда
		СписокАдресовОтвета.Вставить(0, АдресОтвета, АдресОтвета);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета",
		СписокАдресовОтвета);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПриведенныйПочтовыйАдресВФормате(Текст)
	АдресаСтрокой = "";
	Адреса = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Текст);
	
	Если Адреса.Количество() > 1 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Можно указывать только один адрес для ответа.'"), , "АдресОтвета");
		Возврат Текст;
	КонецЕсли;
	
	Для Каждого ОписаниеАдреса Из Адреса Цикл
		Если Не ПустаяСтрока(ОписаниеАдреса.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеАдреса.ОписаниеОшибки, , "АдресОтвета");
		КонецЕсли;
		
		Если Не ПустаяСтрока(АдресаСтрокой) Тогда
			АдресаСтрокой = АдресаСтрокой + "; ";
		КонецЕсли;
		АдресаСтрокой = АдресаСтрокой + АдресСтрокой(ОписаниеАдреса);
	КонецЦикла;
	
	Возврат АдресаСтрокой;
КонецФункции

&НаКлиенте
Функция АдресСтрокой(ОписаниеАдреса)
	Результат = "";
	Если ПустаяСтрока(ОписаниеАдреса.Псевдоним) Тогда
		Результат = ОписаниеАдреса.Адрес;
	Иначе
		Если ПустаяСтрока(ОписаниеАдреса.Адрес) Тогда
			Результат = ОписаниеАдреса.Псевдоним;
		Иначе
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 <%2>", ОписаниеАдреса.Псевдоним, ОписаниеАдреса.Адрес);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПриЗагрузкеВложений(Файлы, ДополнительныеПараметры) Экспорт
	
	Если Файлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьФайлыВСписок(Файлы);
	ОбновитьПредставлениеВложений();
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВложенияИзФайлов()
	
	Для Каждого Вложение Из Вложения Цикл
		Если Не ПустаяСтрока(Вложение.ПутьКФайлу) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(Вложение.ПутьКФайлу);
			Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередЗакрытиемФормы()
	ТекстВопроса = НСтр("ru = 'Сообщение еще не отправлено. Закрыть форму?'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытиеФормыПодтверждено", ЭтотОбъект);
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не закрывать'"));
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,,
		КодВозвратаДиалога.Отмена, НСтр("ru = 'Отправка сообщения'"));
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФормыПодтверждено(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяПодтверждениеЗакрытияФормы = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакШаблон(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		МодульШаблоныСообщенийКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ШаблоныСообщенийКлиентСервер");
		ПараметровШаблона = МодульШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона();
		МодульШаблоныСообщенийКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ШаблоныСообщенийКлиент");
		ПараметровШаблона.Тема = ТемаПисьма;
		ПараметровШаблона.Текст = ТелоПисьма.ПолучитьТекст();
		ПараметровШаблона.ТипШаблона = "Письмо";
		МодульШаблоныСообщенийКлиент.ПоказатьФормуШаблона(ПараметровШаблона);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Результат - см. ШаблоныСообщенийСлужебный.СформироватьСообщение
//  ДополнительныеПараметры - Произвольный
//
&НаКлиенте
Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ТемаПисьма = Результат.Тема;
		УстановитьТекстПисьмаИВложения(Результат.Текст, Результат.Вложения);
		ОбновитьПредставлениеВложений();
		
		Если ТипЗнч(Результат.Получатель) = Тип("СписокЗначений") Тогда
			Для Каждого Получатель Из Результат.Получатель Цикл
				АдресПолучателя                 = ПочтовыеАдресаПолучателей.Добавить();
				АдресПолучателя.ВариантОтправки = "Кому";
				АдресПолучателя.Представление   = Получатель.Представление;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПисьмаИВложения(Текст, СтруктураВложений)
	
	ВложенияHTML = Новый Структура();
	Если ТипЗнч(СтруктураВложений) = Тип("Массив") Тогда
		Для каждого Вложение Из СтруктураВложений Цикл
			ОпределитьНазначениеВложенияПисьма(Вложение, ВложенияHTML);
		КонецЦикла;
	КонецЕсли;
		
	ТелоПисьма.УстановитьHTML(Текст, ВложенияHTML);
	
КонецПроцедуры

&НаКлиенте
Функция ПочтовыйАдресИзПредставления(Знач Представление)
	
	Адрес = Представление;
	ПозицияНачало = СтрНайти(Представление, "<");
	Если ПозицияНачало > 0 Тогда
		ПозицияОкончание = СтрНайти(Представление, ">", НаправлениеПоиска.СНачала, ПозицияНачало);
		Если ПозицияОкончание > 0 Тогда
			Адрес = Сред(Представление, ПозицияНачало + 1, ПозицияОкончание - ПозицияНачало - 1);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СокрЛП(Адрес);

КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПолучателейИзМассиваСтруктур(ПараметрыПолучателейСообщения)
	
	Для Каждого ПараметрыПолучателя Из ПараметрыПолучателейСообщения Цикл
		Если ЗначениеЗаполнено(ПараметрыПолучателя.Адрес) Тогда
			Адрес = СтрЗаменить(ПараметрыПолучателя.Представление, ",", " ") + " < "+ ПараметрыПолучателя.Адрес + ">";
			
			Если ПараметрыПолучателя.Свойство("ВидПочтовогоАдреса") 
				И ЗначениеЗаполнено(ПараметрыПолучателя.ВидПочтовогоАдреса) Тогда
				Представление = Адрес + " (" + ПараметрыПолучателя.ВидПочтовогоАдреса + ")";
			ИначеЕсли ПараметрыПолучателя.Свойство("ИсточникКонтактнойИнформации")
				И ЗначениеЗаполнено(ПараметрыПолучателя.ИсточникКонтактнойИнформации) Тогда
				Представление = Адрес + " (" + Строка(ПараметрыПолучателя.ИсточникКонтактнойИнформации) + ")";
			Иначе
				Представление = Адрес;
			КонецЕсли;
			ПолучателиСообщения.Добавить(Адрес, Представление);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПолучателейИзСтроки(Знач ПараметрыПолучателейСообщения)
	
	ПараметрыПолучателейСообщения = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(ПараметрыПолучателейСообщения);
	
	Для Каждого ПараметрыПолучателя Из ПараметрыПолучателейСообщения Цикл
		Если ЗначениеЗаполнено(ПараметрыПолучателя.Адрес) Тогда
			ПолучателиСообщения.Добавить(ПараметрыПолучателя.Адрес, ПараметрыПолучателя.Псевдоним);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьВложения(АдресаВложений)
	Для Каждого АдресВложения Из АдресаВложений Цикл
		УдалитьИзВременногоХранилища(АдресВложения);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьПолучателейВИсторию(ПолучателиПисьма)
	
	ИсторияПолучателей = ИсторияПолучателей();
	Для Каждого Получатель Из ПолучателиПисьма Цикл
		ИсторияПолучателей.Вставить(Получатель.Адрес, Получатель.Представление);
	КонецЦикла;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РедактированиеНовогоПисьма", "ИсторияПолучателей", ИсторияПолучателей);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИсторияПолучателей()
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РедактированиеНовогоПисьма", "ИсторияПолучателей", Новый Соответствие);
	
КонецФункции

&НаКлиенте
Функция ПредставлениеАдреса(Адрес, ПредставлениеПолучателя)
	Результат = Адрес;
	Если Не ПустаяСтрока(ПредставлениеПолучателя) Тогда
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 <%2>", ПредставлениеПолучателя, Адрес);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ПохожиеПолучателиИзИстории(Строка)
	
	Результат = Новый СписокЗначений;
	Если СтрДлина(Строка) = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ИсторияПолучателей = Неопределено Тогда
		ИсторияПолучателей = ИсторияПолучателей();
	КонецЕсли;
	
	Для Каждого Получатель Из ИсторияПолучателей Цикл
		ПредставлениеАдреса = ПредставлениеАдреса(Получатель.Ключ, Получатель.Значение);
		Позиция = СтрНайти(НРег(ПредставлениеАдреса), НРег(Строка));
		Если Позиция > 0 Тогда
			ПодстрокаДоВхождения = Лев(ПредставлениеАдреса, Позиция - 1);
			ПодстрокаВхождения = Сред(ПредставлениеАдреса, Позиция, СтрДлина(Строка));
			ПодстрокаПослеВхождения = Сред(ПредставлениеАдреса, Позиция + СтрДлина(Строка));
			СтрокаСПодсветкой = Новый ФорматированнаяСтрока(
				ПодстрокаДоВхождения,
				Новый ФорматированнаяСтрока(ПодстрокаВхождения, ШрифтСтиляВажнаяНадписьШрифт(), РезультатУспехЦвет),
				ПодстрокаПослеВхождения);
			Результат.Добавить(ПредставлениеАдреса, СтрокаСПодсветкой);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПохожиеПолучателиИзСпискаПереданных(Знач Текст)
	
	Результат = Новый СписокЗначений;
	
	СписокАдресов = Новый Массив;
	Для каждого СтрокаТаблицы Из ПочтовыеАдресаПолучателей Цикл
		Адрес = ПочтовыйАдресИзПредставления(СтрокаТаблицы.Представление);
		Если ЗначениеЗаполнено(Адрес) Тогда
			СписокАдресов.Добавить(ВРег(Адрес));
		КонецЕсли;
	КонецЦикла;
	
	ПредставлениеВыбор = Новый ФорматированнаяСтрока(Текст, ШрифтСтиляВажнаяНадписьШрифт(), РезультатУспехЦвет);
	ДлинаТекста = СтрДлина(Текст);
	Для Каждого Почта Из ПолучателиСообщения Цикл
		Адрес = ПочтовыйАдресИзПредставления(Почта.Значение);
		Если СписокАдресов.Найти(ВРег(Адрес)) = Неопределено Тогда
			Позиция = СтрНайти(Почта.Значение, Текст);
			Если Позиция > 0 Тогда
				Представление= Новый ФорматированнаяСтрока(Лев(Почта.Представление, Позиция - 1), ПредставлениеВыбор, Сред(Почта.Представление, Позиция + ДлинаТекста));
				Результат.Добавить(Почта.Значение, Представление);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ШрифтСтиляВажнаяНадписьШрифт()
	Возврат ОбщегоНазначенияКлиент.ШрифтСтиля("ВажнаяНадписьШрифт");
КонецФункции
	

#КонецОбласти
