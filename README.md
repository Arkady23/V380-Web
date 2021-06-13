# V380-Web
Web server for ip cameras V380. Russian and English interfaces are supported.  
### The HTTP server allows you to
- perform all sorts of manipulations with the records on the sd card. Now you do not need to take it out of the camera every time;
- watch the video archive on sd online without removing the card;
- display camera information;
- launch services (RTSP, telnet, HTTP);
- restart and safely shut down the camera before turning off the power.  
### HTTP-сервер позволяет
- производить всевозможные манипуляции с записями на sd-карте. Теперь вынимать её из камеры каждый раз вам нет необходимости;
- смотреть видео-архив на sd онлайн, не вынимая карты;
- отображать сведения о камере;
- производить запуск служб (RTSP, telnet, HTTP);
- перезагружать и безопасно завершать работу камеры перед отключением питания.
### Таблица определения модели камеры V380
| Camera | Оборудование / Hwprefix | Модель / Hwname | Установщик / Installer |
| --- | --- | --- | --- |
| V380 ... | HwGMS_WF1_CARD | GM35SCOMMON_V2 |  |
| V380 ... | HwV380E2_WF1_PTZ |  |  |
| V380 mini | HwV380E12_WF3_PCARD | V380E2_C2 | httpd_V380E2_C2_v20210530.zip |
| [V380 mini](https://aliexpress.ru/item/4000944546368.html) | HwV380E12_WF3_AK_MINI | V380E2_C2#YW |  |
| V380 ... | HwV380E21_WF3_PTZ_ETH | V380E3_C3? |  |
| V380 ... | HwV380E21_WF5_PTZ_WIFI | V380E3_C5 | httpd_V380E3_C5_v20210607.zip |
| V380 ... | HwV380E23_WF3_PTZ_ETH | V380E3_C? |  |

Для каждой модели камеры с разными Hwname (он же Soft-id) свой установщик. Вы должны знать этот код. Но если ошибетесь — ничего страшного... патч будет игнорирован. Никаких изменений в камере не производится. Только обеспечивается запуск командного файла на sd в папке ark-add-on — startup.sh, если этот запускной файл есть на карте. Ваша базовая прошивка может быть самой последней. Вся установка происходит на sd-карту. Если после установки очистить или вынуть sd, то камера будет работать в обычном режиме, как работала до установки. Для подготовки установщика к новым моделям — сообщите её Hwprefix и Hwname. Узнать Hwname можно по трафику с камеры в момент захода на смартфоне в пункт "версия прошивки". Также можно определить Hwname, если взять скриншот с экрана смартфона при отображении информации о выходе новой прошивки по её идентификатору.
### Установка
1. Отформатировать sd-карту в FAT32.
2. Записать в корень карты содержимое архива в составе:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Вставить карту в камеру и включить её... ждать пару минут. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
### Installation
1. Format the sd card to FAT32.
2. Write to the root of the sd-card the contents of the archive as part of:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera should reboot. After that, you can use the Internet browser to access the address of the camera.  

![Просмотр папок с записями](Screenshots/image_2021_05_30T07_36_48_243Z.png?raw=true)  

![Просмотр видео записей за сутки](Screenshots/image_2021_05_30T07_37_52_174Z.png?raw=true)  

![Просмотр сведений о камере](Screenshots/image_2021_05_30T07_38_32_727Z.png?raw=true)  

![Просмотр основных настроек](Screenshots/image_2021_05_30T07_39_06_740Z.png?raw=true)  

![Просмотр дполнительных настроек](Screenshots/image_2021_05_30T07_39_26_478Z.png?raw=true)
