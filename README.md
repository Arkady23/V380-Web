# V380-Web
Web server for ip cameras V380. Russian and English interfaces are supported.  
### The HTTP server allows you to
- perform all sorts of manipulations with the records on the sd card. Now you do not need to take it out of the camera every time;
- watch the video archive on sd online without removing the card;
- display camera information;
- launch services (RTSP, telnet, ftp, HTTP);
- restart and safely shut down the camera before turning off the power.  
### HTTP-сервер позволяет
- производить всевозможные манипуляции с записями на sd-карте. Теперь вынимать её из камеры каждый раз вам нет необходимости;
- смотреть видео-архив на sd онлайн, не вынимая карты;
- отображать сведения о камере;
- производить запуск служб (RTSP, telnet, ftp, HTTP);
- перезагружать и безопасно завершать работу камеры перед отключением питания.
### Таблица определения модели камеры V380
| Camera | Оборудование / Hwprefix | Модель / Hwname | Установщик / Installer |
| --- | --- | --- | --- |
| V380 | Любая камера<br>Any camera | установка вручную<br>manual setup | [httpd_V380_any_manual.zip](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260106/httpd_V380_any_manual.zip) |

Ваша базовая прошивка может быть самой последней. Вся установка происходит на sd-карту. Если после установки очистить или вынуть sd, то камера будет работать в обычном режиме, как работала до установки.
### Установка
1. Отформатировать sd-карту в FAT32, например, используя программу Rufus в режиме незагрузочного диска.
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260106/httpd_V380_any_manual.zip) в составе:
- ark-add-on
- bin
- quick_check.ini
- setup.sh
3. Вставить карту в камеру и включить её... ждать пару минут. Камера включется с запущенным сервером telnet. После чего нужно зайти через telnet по адресу камеры (логин root, пароль посмотреть в файле quick_check.ini).
4. Ввести команду через telnet:<br>
    /mnt/sdcard/setup.sh
5. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
### Installation
1. Format the sd-card to FAT32, for example using Rufus in non-bootable disk mode.
2. Write to the root of the sd-card the contents of [the archive](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260106/httpd_V380_any_manual.zip) as part of:
- ark-add-on
- bin
- quick_check.ini
- setup.sh
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera turns on with the telnet server running. After that, you need to log in via telnet to the camera address (login root, password look in the file quick_check.in).
4. Enter command via telnet:<br>
    /mnt/sdcard/setup.sh<br>
5. The camera should reboot. After that, you can use the Internet browser to access the address of the camera. 
### News
**18.01.2026**. A bug with the load.sh update download script has been fixed. Please replace this script in the cg-bin folder on your SD card, as only updates will be published in the future, not the initial installer. The script must be downloaded from [this page](https://github.com/Arkady23/V380-Web/blob/main/src/cgi-bin/load.sh). If you were able to replace this script, you can update the server from the update_20260118.tar file on the settings page. Or simply reinstall the entire server from the httpd_V380_any_manual.zip file from 01/18/2026.  
Исправлена ошибка скрипта загрузки обновлений load.sh. Пожалуйста замените этот скрипт на sd-карте в папке cg-bin, т.к. в дальнейшем будут публиковаться только обновления, а не начальный установщик. Скрипт необходимо скачать с [этой страницы](https://github.com/Arkady23/V380-Web/blob/main/src/cgi-bin/load.sh). Если вы смогли заменить этот скрипт, вы можете обновить сервер из файла update_20260118.tar на странице с настройками. Или просто переустановите весь сервер из файла httpd_V380_any_manual.zip от 18.01.2026.  

![Просмотр основных настроек](screenshots/image_2022_08_21T23_12_43_133Z.png?raw=true)
