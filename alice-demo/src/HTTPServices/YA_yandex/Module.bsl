
Функция aliceОбработкаЗапроса(Запрос)

	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеЗапроса = Я_ОбработкаJSON.JSONВОбъект(Запрос.ПолучитьТелоКакСтроку());
	
	ТекстОтвета = Неопределено;
	
	Попытка
		ОбработанныйЗапрос = ОбработатьЗапрос(ДанныеЗапроса);		
		ТекстОтвета = Я_Алиса.ОтветАлисе(ОбработанныйЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации("ОшибкаОбработкиЗапросаАлисы", УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ЗаписьЛога = Документы.YA_Логи.СоздатьДокумент();
	ЗаписьЛога.Дата = ТекущаяДатаСеанса();
	ЗаписьЛога.Метод = Запрос.HTTPМетод;
	ЗаписьЛога.ТелоЗапроса = Я_ОбработкаJSON.ОбъектВJSON(ДанныеЗапроса);
	ЗаписьЛога.ТелоОтвета = ТекстОтвета;
	ЗаписьЛога.Записать();
	
	Если ТекстОтвета = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(500); 
		Ответ.УстановитьТелоИзСтроки("Внутренняя ошибка сервера");
	Иначе
		Ответ = Новый HTTPСервисОтвет(200); 
		Ответ.УстановитьТелоИзСтроки(ТекстОтвета);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ОбработатьЗапрос(ДанныеЗапроса)
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИдентификаторСессии", ДанныеЗапроса.session.session_id);
	Результат.Вставить("Команда", НРег(ДанныеЗапроса.request.command));
	Результат.Вставить("СостояниеСессии", 
		Я_ОбщегоНазначения.СвойствоСтруктуры(ДанныеЗапроса, "state.session"));
	
	Возврат Результат;	
	
КонецФункции

Функция PingGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);  
	Ответ.УстановитьТелоИзСтроки("Ok");
	Возврат Ответ;
КонецФункции
