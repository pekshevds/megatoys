///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	УстановитьДатыПоУмолчанию();
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
КонецПроцедуры

Функция ЭтоРабочийДень(ДанныеПроизводственногоКалендаря, ПроверяемаяДата)
	Строки = ДанныеПроизводственногоКалендаря.НайтиСтроки(Новый Структура("Дата", ПроверяемаяДата));
	
	Если Строки.Количество() = 0 Тогда 
		
		Возврат Истина;
	КонецЕсли;
	
	Строка0 = Строки[0];
	Возврат Строка0.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий;
КонецФункции

Функция ПолучитьГодыПериода()
	
	Годы = Новый Массив;
	Годы.Добавить(Год(НачалоПериода));
	Если Годы.Найти(Год(КонецПериода)) = Неопределено Тогда 
		
		Годы.Добавить(Год(КонецПериода));
	КонецЕсли;   
	
	Возврат Годы;
КонецФункции

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	Годы = ПолучитьГодыПериода();
	ДанныеПроизводственногоКалендаря = 
		Справочники.ПроизводственныеКалендари.ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, Годы);
	ДанныеПроизводственногоКалендаря.Индексы.Добавить("Дата");
	
	Движения.mega_ПроизводственныеРесурсы.Записывать = Истина;
	
	ОдинДень = 24*60*60;
	ВременнаяДата = НачалоПериода;
	
	Пока ВременнаяДата <= КонецПериода Цикл 
		
		Если ЭтоРабочийДень(ДанныеПроизводственногоКалендаря, ВременнаяДата) Тогда 
			
			Для Каждого ТекСтрокаПроизводственныеРесурсы Из ПроизводственныеРесурсы Цикл
				Движение = Движения.mega_ПроизводственныеРесурсы.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.ДатаРесурса = ВременнаяДата;
				Движение.Ресурс = ТекСтрокаПроизводственныеРесурсы.Ресурс;
				Движение.Время = ТекСтрокаПроизводственныеРесурсы.Время;
			КонецЦикла;
		КонецЕсли;
		ВременнаяДата = ВременнаяДата + ОдинДень;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УстановитьДатыПоУмолчанию();
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если КонецПериода < НачалоПериода Тогда

		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата окончания не может быть меньше даты начала.'"),
			,
			"КонецПериода",
			,
			Отказ);

	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДатыПоУмолчанию()

	НачалоПериода = НачалоГода(ТекущаяДатаСеанса());
	КонецПериода = КонецГода(ТекущаяДатаСеанса());

КонецПроцедуры


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли