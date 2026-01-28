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
| Оборудование / Hwprefix | Модель / Hwname | Установщик / Installer |
| --- | --- | --- |
| Любая камера с telnet<br>Any camera with telnet | установка вручную<br>manual setup | [httpd_V380_any_manual.zip](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260127/httpd_V380_any_manual.zip) |
| HW_HsAkQQWG_WIFI_COMM без telnet | KM01D_WF | [httpd_KM01D_WF-setup.zip](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260127/httpd_KM01D_WF-setup.zip) |

Вся установка происходит на sd-карту. Если после установки очистить или вынуть sd, то камера будет работать в обычном режиме, как работала до установки.  
### Когда установка невозможна
В настоящее время появляется большое количество типов камер, работающих на базовом ПО V380. Последнее время производители закрывают доступ к telnet. В этом случае можно получить доступ к камере, но только если вам удастся перехватить очередной патч, который может поступить на камеру через интернет. Если приложение на смартфоне уведомляет вас о наличии нового обновления — не торопитесь его установить. Попробуйте перехватить трафик и получить ссылку на скачивание вашего патча. Создайте тему в дискусиях или в пуле запросов и приложите свой патч для вашей камеры. Тогда я смогу доработать установщик web-сервера для вашей камеры и другие члены сообщества смогут им воспользоваться.
### Установка
1. Отформатировать sd-карту в FAT32, например, используя программу Rufus в режиме незагрузочного диска. Некоторые новые sd-карты большого объема форматируются только в exFAT.
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260127/httpd_V380_any_manual.zip) в составе:

| Для камер с telnet | Для камер без telnet |
| --- | --- |  
| &bull; ark-add-on<br>&bull; bin<br>&bull; quick_check.ini<br>&bull; setup.sh | &bull; ark-add-on<br>&bull; bin<br>&bull; updatepatch<br>&bull; local_update.conf<br>&bull; patch_reuse |  
3. Вставить карту в камеру и включить её... ждать пару минут. Камера включется с запущенным сервером telnet. После чего нужно зайти через telnet по адресу камеры (логин root, пароль посмотреть в файле quick_check.ini).
4. Ввести команду через telnet (этот пункт выполняется для тех камер, которые предоставляют telnet):<br>
    /mnt/sdcard/setup.sh
5. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
### When installation is not possible
A large number of cameras running the V380 base software are currently appearing. Recently, manufacturers have been blocking access to Telnet. In this case, you can still access the camera, but only if you manage to intercept the latest patch that might arrive via the internet. If the smartphone app notifies you of a new update, don't rush to install it. Try intercepting the traffic and getting a download link for your patch. Create a thread in the discussions or request pool and attach your patch for your camera. Then I can refine the web server installer for your camera, and other community members will be able to use it.
### Installation
1. Format the sd-card to FAT32, for example using Rufus in non-bootable disk mode. Some newer, larger capacity sd-cards are only formatted to exFAT.
2. Write to the root of the sd-card the contents of [the archive](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260127/httpd_V380_any_manual.zip) as part of:

| For cameras with telnet | For cameras without telnet |  
| --- | --- |
| &bull; ark-add-on<br>&bull; bin<br>&bull; quick_check.ini<br>&bull; setup.sh | &bull; ark-add-on<br>&bull; bin<br>&bull; updatepatch<br>&bull; local_update.conf<br>&bull; patch_reuse |
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera turns on with the telnet server running. After that, you need to log in via telnet to the camera address (login root, password look in the file quick_check.in).
4. Enter command via telnet (this item is performed for those cameras that provide telnet):<br>
    /mnt/sdcard/setup.sh<br>
5. The camera should reboot. After that, you can use the Internet browser to access the address of the camera. 
### News
**23.01.2026**. Optimization of scripts has been completed.  
Произведена оптимизация скриптов.  
**18.01.2026**. A bug with the load.sh update download script has been fixed. Please replace this script in the cgi-bin folder on your sd-card, as only updates will be published in the future, not the initial installer. The script must be downloaded from [this page](https://github.com/Arkady23/V380-Web/blob/main/src/cgi-bin/load.sh). If you were able to replace this script, you can update the server from the [update_20260118.tar](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260118/update_20260118.tar) file on the camera settings page. Or simply reinstall the entire server from the [httpd_V380_any_manual.zip](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260118/httpd_V380_any_manual.zip) file from 01/18/2026.  
Otherwise, the January 18, 2026 version remains functionally unchanged, with the exception of a switch from the slow lot.sh function for searching data in text files to awk scripts, which perform this task much faster. After this update, the camera will respond somewhat more quickly to requests.  

Исправлена ошибка скрипта загрузки обновлений load.sh. Пожалуйста замените этот скрипт на sd-карте в папке cgi-bin, т.к. в дальнейшем будут публиковаться только обновления, а не начальный установщик. Скрипт необходимо скачать с [этой страницы](https://github.com/Arkady23/V380-Web/blob/main/src/cgi-bin/load.sh). Если вы смогли заменить этот скрипт, вы можете обновить сервер из файла [update_20260118.tar](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260118/update_20260118.tar) на странице с настройками камеры. Или просто переустановите весь сервер из файла [httpd_V380_any_manual.zip](https://github.com/Arkady23/V380-Web/releases/download/Initial-installer-20260118/httpd_V380_any_manual.zip) от 18.01.2026.  
В остальном версия от 18.01.2026 функционально не изменилась за исключением перехода с медленной функции lot.sh поиска даннык в текстовых файлах на скрипты awk, которые это делают значительно быстрее. После этого обновления камера будет несколько быстрее реагировать на запросы.  

![Просмотр основных настроек](screenshots/image_2022_08_21T23_12_43_133Z.png?raw=true)
