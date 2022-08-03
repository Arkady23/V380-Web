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
| V380 | HwGMS_WF1_CARD | GM35SCOMMON_V2 | [httpd_GM35SCOMMON_V2.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_GM35SCOMMON_V2_9090909_v20210620.zip) |
| [V380 HD 720P](https://aliexpress.ru/item/33010593004.html) | HwV380E2_WF1_PTZ | V380E_C2 | [httpd_V380E_C2.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E_C2_9090909_v20210620.zip) |
| V380 | HwV380E11_WF3_IPC38_ETH<br>HwV380E11_WF9_IPC38_ETH<br>HwV380E12_WF3_PCARD<br>HwV380E12_WF9_PTZ | V380E2_C2 | [httpd_V380E2_C2.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E2_C2_9090909_v20210620.zip) |
| [V380 mini](https://aliexpress.ru/item/4000944546368.html) | HwV380E12_WF3_AK_MINI<br>HwV380E12_WF6_AK_MINI | V380E2_C2#YW | [httpd_V380E2_C2.YW.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E2_C2.YW_9090909_v20210620.zip) |
| V380 | HwV380E12_WF3_PTZ<br>HwV380E13_WF3_PTZ | V380E2_CA | [httpd_V380E2_CA.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E2_CA_9090909_v20210620.zip) |
| V380 | HwV380E21_WF3_PTZ_ETH | V380E3_C3 | [httpd_V380E3_C3.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E3_C3_9090909_v20210620.zip) |
| V380 | HwV380E21_WF5_PTZ_WIFI<br>HwV380E21_WF6_PTZ_WIFI | V380E3_C5 | [httpd_V380E3_C5.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E3_C5_9090909_v20210620.zip) |
| V380 Door Eye | HwV380E22_WF3_MINI_Q7 | V380E3_C5#YW | [httpd_V380E3_C5.YW.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E3_C5.YW_9090909_v20210620.zip) |
| V380 | HwV380E21_WF3_PTZ_WIFI | V380E3_C6 | [httpd_V380E3_C6.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E3_C6_9090909_v20210620.zip) |
| [V380](https://aliexpress.ru/item/4001018956901.html) | A9_J3 | JL_A9C |  |
| V380 | HwV380E23_WF3_IPC_ETH | V380E3_CA | [httpd_V380E3_CA.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E3_CA_9090909_v20210620.zip) |
| V380 | HwV380E31_WF3_IPC60_ETH<br>HwV380E31_WF6_PTZ_WIFI<br>HwV380E31_WF8_PTZ_WIFI | V380E4_C3 | [httpd_V380E4_C3.zip](https://github.com/Arkady23/V380-Web/releases/download/20210530/httpd_V380E4_C3_9090909_v20210620.zip) |

Для каждой модели камеры с разными Hwname (он же Soft-id) свой установщик. Вы должны знать этот код, а в некоторых случаях и 7-и значный номер версии прошивки (последнего патча). Но если ошибетесь — ничего страшного... патч будет игнорирован. Никаких изменений в камере не производится. Только обеспечивается запуск командного файла на sd в папке ark-add-on — startup.sh, если этот запускной файл есть на карте. Ваша базовая прошивка может быть самой последней. Вся установка происходит на sd-карту. Если после установки очистить или вынуть sd, то камера будет работать в обычном режиме, как работала до установки. Для подготовки установщика к новым моделям — сообщите её Hwprefix, Hwname и 7-и значный номер версии прошивки. Узнать Hwname и версию можно по трафику с камеры в момент захода на смартфоне в пункт "версия прошивки". Также эту информацию можно увидеть в протоколе загрузки, если вы сможете подключить камеру к последовательному порту. Хорошим способом является обращение в поддержку v380technical(собака)gmail.com для получения последнего обновления от производителя. Последнее обновление можно также скачать самостоятельно с официального ресурса http://update2017.oss-accelerate.aliyuncs.com/..., но для каждой модели своя url-строка и уточнить её опять таки можно только сняв трафик с камеры. Можно определить Hwname, если взять скриншот с экрана смартфона при отображении информации о выходе новой прошивки по её идентификатору. Обучающий ролик, как поймать трафик с камеры https://youtu.be/GLYqb2cC4y0.
### Установка
1. Отформатировать sd-карту в FAT32 ([Вот эта программа](http://ridgecrop.co.uk/index.htm?guiformat.htm) подходит).
#### Для камер с версиями прошивок до 2019 года
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/tag/20210530) в составе:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Вставить карту в камеру и включить её... ждать пару минут. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
#### Для камер с версиями прошивок после 2019 года
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/tag/20210530) в составе:
- ark-add-on
- quick_check.ini
- exshell_bfu.sh
3. Вставить карту в камеру и включить её... ждать пару минут. Камера включется с запущенным сервером telnet. После чего нужно зайти через telnet по адресу камеры (логин root, пароль посмотреть в файле quick_check.ini).
4. Ввести команду: /mnt/sdcard/exshell_bfu.sh
### Installation
#### For cameras with firmware versions up to 2019
1. Format the sd card to FAT32 ([Here this program](http://ridgecrop.co.uk/index.htm?guiformat.htm) is suitable).
2. Write to the root of the sd-card the contents of [the archive](https://github.com/Arkady23/V380-Web/releases/tag/20210530) as part of:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera should reboot. After that, you can use the Internet browser to access the address of the camera.  
#### For cameras with firmware versions after 2019

![Просмотр папок с записями](Screenshots/image_2021_05_30T07_36_48_243Z.png?raw=true)  

![Просмотр видео записей за сутки](Screenshots/image_2021_05_30T07_37_52_174Z.png?raw=true)  

![Просмотр сведений о камере](Screenshots/image_2021_05_30T07_38_32_727Z.png?raw=true)  

![Просмотр основных настроек](Screenshots/image_2021_05_30T07_39_06_740Z.png?raw=true)  

![Просмотр дполнительных настроек](Screenshots/image_2021_05_30T07_39_26_478Z.png?raw=true)
