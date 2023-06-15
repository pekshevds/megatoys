#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьМатериалыСпецификации(Спецификация, Количество) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Материалы.Номенклатура,
		|	Материалы.Количество / Материалы.Ссылка.Количество * &Количество КАК Количество,
		|	Материалы.ЕдиницаИзмерения
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьПервуюНеПомеченнуюНаУдалениеСпецификацию(Номенклатура)Экспорт 
	Спецификация = ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	mega_Спецификации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.mega_Спецификации КАК mega_Спецификации
	|ГДЕ
	|	mega_Спецификации.Владелец = &Номенклатура
	|	И НЕ mega_Спецификации.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
		
	Если Выборка.Следующий() Тогда 
		
		Спецификация = Выборка.Ссылка;		
	КонецЕсли;                                
	
	Возврат Спецификация;
КонецФункции

// Получить основную спецификацию номенклатуры.
// 
// Параметры:
//  Номенклатура - СправочникСсылка.mega_Номенклатура - Номенклатура, основную спецификацию которой нужно получить
// 
// Возвращаемое значение:
//  СправочникСсылка.mega_Спецификации - СправочникСсылка.mega_Спецификации
Функция ПолучитьОсновнуюСпецификациюНоменклатуры(Номенклатура)Экспорт 
	
	ОсновнаяСпецификация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "Спецификация");
	Если ЗначениеЗаполнено(ОсновнаяСпецификация) Тогда 
		
		Возврат ОсновнаяСпецификация;
	КонецЕсли;
	
	Возврат ПолучитьПервуюНеПомеченнуюНаУдалениеСпецификацию(Номенклатура);
КонецФункции

Функция ПолучитьПервуюСтадиюОбработки(Спецификация)Экспорт	
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;	
	
	ПерваяСтрока = Спецификация.СтадииОбработки[0];
	ЗаполнитьЗначенияСвойств(Структура, ПерваяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьПоследнююСтадиюОбработки(Спецификация)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;	
	
	ПоследняяСтрока = Спецификация.СтадииОбработки[Спецификация.СтадииОбработки.Количество() - 1];
	ЗаполнитьЗначенияСвойств(Структура, ПоследняяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки)Экспорт
	
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Строки = Спецификация.СтадииОбработки.НайтиСтроки(Новый Структура("ВидСтадииОбработки", ВидСтадииОбработки));
	Если Строки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	НайденнаяСтрока = Строки[0];
	ЗаполнитьЗначенияСвойств(Структура, НайденнаяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьПредыдущуюСтадиюОбработки(Спецификация, ТекущаяСтадияОбработки)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Если ТекущаяСтадияОбработки.НомерСтроки <= 1 Тогда 
		
		Возврат Структура;
	КонецЕсли;
		
	ПредыдущаяСтрока = Спецификация.СтадииОбработки[(ТекущаяСтадияОбработки.НомерСтроки - 1) - 1];
	ЗаполнитьЗначенияСвойств(Структура, ПредыдущаяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьСледующуюСтадиюОбработки(Спецификация, ТекущаяСтадияОбработки)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	КоличествоСтадийОбработки = Спецификация.СтадииОбработки.Количество();
	
	
	Если КоличествоСтадийОбработки = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Если ТекущаяСтадияОбработки.НомерСтроки = КоличествоСтадийОбработки ИЛИ 
		ТекущаяСтадияОбработки.НомерСтроки = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
		
	СледующаяСтрока = Спецификация.СтадииОбработки[ТекущаяСтадияОбработки.НомерСтроки];
	ЗаполнитьЗначенияСвойств(Структура, СледующаяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьВремяПроизводстваЕдиницыСпецификации(Спецификация, Количество = 1)Экспорт
	Время = 0;
	
	Для Каждого ТекСтрокаТехнологическиеОперации Из Спецификация.ТехнологическиеОперации Цикл 
		
		Время = Время + (ТекСтрокаТехнологическиеОперации.ВремяВыполнения / Спецификация.Количество * Количество);
	КонецЦикла;
	
	Возврат Время;
КонецФункции

Функция ПолучитьДоступныеВидыСтадийОбработки(Спецификация)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииСтадииОбработки.ВидСтадииОбработки
		|ИЗ
		|	Справочник.mega_Спецификации.СтадииОбработки КАК mega_СпецификацииСтадииОбработки
		|ГДЕ
		|	mega_СпецификацииСтадииОбработки.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВидСтадииОбработки");
КонецФункции

Функция ПолучитьДоступныеТехнологическиеОперации(Спецификация, ВидСтадииОбработки = Неопределено)Экспорт
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда
		
		Возврат Новый Массив;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидСтадииОбработки) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	mega_СпецификацииТехнологическиеОперации.Номенклатура
			|ИЗ
			|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
			|ГДЕ
			|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация";
		
		Запрос.УстановитьПараметр("Спецификация", Спецификация);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	КонецЕсли;
	
	Строки = Спецификация.СтадииОбработки.НайтиСтроки(Новый Структура("ВидСтадииОбработки", ВидСтадииОбработки));
	Если Строки.Количество() > 0 Тогда
		
		СтадияОбработки = Строки[0];
		Запрос = Новый Запрос;
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	mega_СпецификацииТехнологическиеОперации.Номенклатура
			|ИЗ
			|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
			|ГДЕ
			|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация
			|	И mega_СпецификацииТехнологическиеОперации.КлючСвязи = &КлючСвязи";
		
		Запрос.УстановитьПараметр("Спецификация", Спецификация);
		Запрос.УстановитьПараметр("КлючСвязи", СтадияОбработки.КлючСвязи);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	КонецЕсли;
	
	Возврат Новый Массив;
КонецФункции

Функция ПолучитьДлительностьТехнологическойОперации(Спецификация, ВидСтадииОбработки, ТехнологическаяОперация)Экспорт
    
    Запрос = Новый Запрос;
    Запрос.Текст =
    	"ВЫБРАТЬ
    	|	ТехнологическиеОперации.ВремяВыполнения / ТехнологическиеОперации.Количество КАК Время
    	|ИЗ
    	|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
    	|ГДЕ
    	|	ТехнологическиеОперации.КлючСвязи В
    	|		(ВЫБРАТЬ
    	|			СтадииОбработки.КлючСвязи
    	|		ИЗ
    	|			Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
    	|		ГДЕ
    	|			СтадииОбработки.Ссылка = &Спецификация
    	|			И СтадииОбработки.ВидСтадииОбработки = &ВидСтадииОбработки)
    	|	И ТехнологическиеОперации.Номенклатура = &ТехнологическаяОперация";
    
    Запрос.УстановитьПараметр("Спецификация", Спецификация);
    Запрос.УстановитьПараметр("ТехнологическаяОперация", ТехнологическаяОперация);
    Запрос.УстановитьПараметр("ВидСтадииОбработки", ВидСтадииОбработки);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    	Возврат ВыборкаДетальныеЗаписи.Время;
    КонецЦикла;
    
	Возврат 0;    
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруВозвратаСтадииОбработки()
	
	Структура = Новый Структура;
	Структура.Вставить("НомерСтроки", 0);
	Структура.Вставить("ВидСтадииОбработки", Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка());
	Структура.Вставить("КлючСвязи", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Возврат Структура;
КонецФункции

#КонецОбласти



#КонецЕсли