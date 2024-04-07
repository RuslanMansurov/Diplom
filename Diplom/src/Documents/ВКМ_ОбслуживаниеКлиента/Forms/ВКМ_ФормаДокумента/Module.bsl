
//{{ВКМ Подключаем к форме подсистему Подключаемые команды
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    
    //{{ВКМ: Получаем путь картинки - скана листа учета рабочего времени
    ДвоичныеДанные = ТекущийОбъект.ВКМ_ФайлКартинки.Получить();
    ВКМ_ПутьЛистаУчетаРабочегоВремени = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
    //}}ВКМ
    
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
    
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
//}}ВКМ

//{{ВКМ Добавляем возможность хранить присоединенный к документу Лист учета рабочего времени
&НаКлиенте
Процедура ВКМ_ПутьЛистаУчетаРабочегоВремениНажатие(Элемент, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;      
    ПрочитатьКартинкуЛистаУчетаРабочегоВремени();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПрочитатьКартинкуЛистаУчетаРабочегоВремени()
	ПараметрыПомещенияФайла = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыПомещенияФайла.Фильтр = "Картинка формата jpg (*.jpg)|*.jpg|Картинка формата bmp (*.bmp)|*.bmp|Картинка формата png (*.png)|*.png"; 
	
	ОписаниеФайла = Ждать ПоместитьФайлНаСерверАсинх(,,, ПараметрыПомещенияФайла, УникальныйИдентификатор);
	
	Если ОписаниеФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеФайла.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;
	
	ВКМ_ПутьЛистаУчетаРабочегоВремени = ОписаниеФайла.Адрес;
КонецПроцедуры    

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ВКМ_ПутьЛистаУчетаРабочегоВремени <> "" Тогда 
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВКМ_ПутьЛистаУчетаРабочегоВремени);
		ТекущийОбъект.ВКМ_ФайлКартинки = Новый ХранилищеЗначения(ДвоичныеДанные);
	КонецЕсли;	
	
	//ВКМ. Получаем дату создания документа 
	ДатаСоздания = ТекущийОбъект.Ссылка.Дата;  
	
	//ВКМ. Если документ записывается впервые создаем сообщение в Справочнике Уведомления Телеграм-боту
	Если ДатаСоздания = Дата("01.01.0001 0:00:00") Тогда 
		
		ТекстНовогоСообщения = СтрШаблон("Появилась новая заявка на обслуживание клиента. 
		|Дата заявки: %1. 
		|Дата проведения работ: %2. 
		|Время начала работы: %3. 
		|Специалист: %4.
		|Сотрудник: %5", 
		Формат(Объект.Дата, "ДФ=dd.MM.yyyy"), Формат(ТекущийОбъект.ВКМ_ДатаПроведенияРабот, "ДФ=dd.MM.yyyy"), 
		Формат(ТекущийОбъект.ВКМ_ВремяНачалаРаботПлан, "ДЛФ=T"), ТекущийОбъект.ВКМ_Специалист, ТекущийОбъект.ВКМ_Сотрудник);
		
		НоваяЗаписьВСправочникУведомленияТелеграмБоту(ТекстНовогоСообщения);
		
		//Если в документе изменилась дата проведения работ, время или специалист, то
		//создаем новое сообщение в Справочнике Уведомления Телеграм-боту
	ИначеЕсли ТекущийОбъект.Ссылка.ВКМ_ДатаПроведенияРабот <> Объект.ВКМ_ДатаПроведенияРабот 
			 ИЛИ ТекущийОбъект.Ссылка.ВКМ_ВремяНачалаРаботПлан <> Объект.ВКМ_ВремяНачалаРаботПлан 
			 ИЛИ ТекущийОбъект.Ссылка.ВКМ_Сотрудник <> Объект.ВКМ_Сотрудник Тогда 
		
		ТекстНовогоСообщения = СтрШаблон("В заявке на обслуживание клиента произошли изменения. 
		|Номер заявки %1. 
		|Дата заявки: %2. 
		|Дата проведения работ: %3. 
		|Время начала работы: %4. 
		|Специалист: %5.
		|Сотрудник: %6", 
		ТекущийОбъект.Ссылка.Номер, Формат(Объект.Дата, "ДФ=dd.MM.yyyy"), Формат(ТекущийОбъект.ВКМ_ДатаПроведенияРабот, "ДФ=dd.MM.yyyy"), 
		Формат(ТекущийОбъект.ВКМ_ВремяНачалаРаботПлан, "ДЛФ=T"), ТекущийОбъект.ВКМ_Специалист, ТекущийОбъект.ВКМ_Сотрудник);
		
		НоваяЗаписьВСправочникУведомленияТелеграмБоту(ТекстНовогоСообщения);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_СохранитьЛистУчетаРабочегоВремени(Команда) 
    
	АдресРезультата = ПодготовитьКартинку();
	
	// Если для документа не загружена картинка листа учеьа рабочего времени, то не будем открывать окно сохранения файла
	Если Не ЗначениеЗаполнено(АдресРезультата) Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыПолученияФайла = Новый ПараметрыДиалогаПолученияФайлов;
	ПолучитьФайлССервераАсинх(АдресРезультата, "Лист учета.jpg", ПараметрыПолученияФайла); 
    //ПолучитьФайлССервераАсинх(АдресРезультата, Объект.Наименование + ".jpg", ПараметрыПолученияФайла);
    
КонецПроцедуры     

&НаСервере
Функция ПодготовитьКартинку()
	
	ДвоичныеДанныеИзображения = ПолучитьИзВременногоХранилища(ВКМ_ПутьЛистаУчетаРабочегоВремени);
	
	Если ДвоичныеДанныеИзображения = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Скан листа учета рабочего времени не загружен";
		Сообщение.Сообщить();
		Возврат Неопределено;
	КонецЕсли;
	
	Картинка = Новый Картинка(ДвоичныеДанныеИзображения);                              

	ОбрабатываемаяКартинка = Новый ОбрабатываемаяКартинка(Картинка);
	ОбрабатываемаяКартинка.УстановитьРазмер(Неопределено, Неопределено);

	Картинка = ОбрабатываемаяКартинка.ПолучитьКартинку();
	
	ДвоичныеДанныеИзображения = Картинка.ПолучитьДвоичныеДанные();
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанныеИзображения, УникальныйИдентификатор);
	
КонецФункции

//ВКМ. Создаем новое сообщение в справочнике ВКМ_УведомленияТелеграмБоту
&НаСервере
Процедура НоваяЗаписьВСправочникУведомленияТелеграмБоту(ТекстНовогоСообщения)
	НовоеСообщение = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
	НовоеСообщение.ВКМ_ТекстСообщения = ТекстНовогоСообщения; 
	НовоеСообщение.Записать();  
КонецПроцедуры
//}}ВКМ






