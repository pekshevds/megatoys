     
// Функция вычисляет контрольный символ кода EAN.
//
// Параметры:
//  Штрихкод - Строка - штрихкод (без контрольной цифры).
//  Тип      - Число - тип штрихкода (13 для EAN13, 8 для EAN8).
//
// Возвращаемое значение:
//  Строка - Контрольный символ штрихкода.
//
Функция КонтрольныйСимволEAN(ШтрихКод, Тип = 13) Экспорт
	
	Четн   = 0;
	Нечетн = 0;

	КоличествоИтераций = ?(Тип = 13, 6, 4);

	Для Индекс = 1 По КоличествоИтераций Цикл
		Если (Тип = 8) И (Индекс = КоличествоИтераций) Тогда
		Иначе
			Четн   = Четн   + Сред(ШтрихКод, 2 * Индекс, 1);
		КонецЕсли;
		Нечетн = Нечетн + Сред(ШтрихКод, 2 * Индекс - 1, 1);
	КонецЦикла;

	Если Тип = 13 Тогда
		Четн = Четн * 3;
	Иначе
		Нечетн = Нечетн * 3;
	КонецЕсли;

	КонтЦифра = 10 - (Четн + Нечетн) % 10;

	Возврат ?(КонтЦифра = 10, "0", Строка(КонтЦифра));

КонецФункции