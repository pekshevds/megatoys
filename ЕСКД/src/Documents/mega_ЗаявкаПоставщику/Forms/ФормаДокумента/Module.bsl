///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 		
КонецПроцедуры   

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Состав	.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|ЕдиницаИзмерения,
		|Количество,
		|Цена,
		|Сумма");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);		
		ПриИзмененииНоменклатурыНаСервере(Структура);		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Состав	.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставЦенаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Состав	.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткамВнутреннихЗаявок(Команда)
	
	Если Объект.Состав.Количество() = 0 Тогда
		
		ЗаполнитьСоставПоОстаткамВнутреннихЗаявокНаСервере();
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ОписаниеОповещенияОЗавершении = 
			Новый ОписаниеОповещения("ПослеЗакрытияВопросаООчисткеТаблицыСостав", ЭтотОбъект);	
		
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, 
			НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?';"), Режим, 0);		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОстаткиНаСервере()
	
	ДатаСреза = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ДатаСреза = КонецДня(ДатаСреза);
	КонецЕсли;	
	Номенклатура = Объект.Состав.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СкладскиеЗапасыОстатки.Номенклатура,
		|	СкладскиеЗапасыОстатки.КоличествоОстаток КАК Остаток
		|ПОМЕСТИТЬ втОстаткиЗаказчика
		|ИЗ
		|	РегистрНакопления.mega_СкладскиеЗапасы.Остатки(&ДатаСреза, Номенклатура В (&Номенклатура)) КАК СкладскиеЗапасыОстатки";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Для Каждого ТекСтрокаСостав Из Объект.Состав Цикл
		
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура", ТекСтрокаСостав.Номенклатура);
		
		ТекСтрокаСостав.Остаток = 0;
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(Структура) Тогда
						
			ТекСтрокаСостав.Остаток = ВыборкаДетальныеЗаписи.Остаток;
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатурыНаСервере(Структура)
	
	Структура.ЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	Структура.Цена = 0;
	Структура.Сумма = 0;	
				
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.ЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Номенклатура, "ЕдиницаИзмерения");
			
		ВыборкаЦен = РегистрыСведений.mega_ЦеныПоставщиков.ПолучитьЦенуНоменклатурыПоставщика(Объект.Поставщик, Структура.Номенклатура, Объект.Дата);
		Если ВыборкаЦен.Следующий() Тогда
			
			Структура.Цена = ВыборкаЦен.Цена;
			Структура.Сумм = Структура.Цена * Структура.Количество;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаООчисткеТаблицыСостав(Результат, Параметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Объект.Состав.Очистить();
		
	ЗаполнитьСоставПоОстаткамВнутреннихЗаявокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоставПоОстаткамВнутреннихЗаявокНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
    ДокументОбъект.ЗаполнитьПоОстаткамВнутреннихЗаявок();
   	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностью()
	

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти 

