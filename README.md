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
| V380 | Любая камера<br>Any camera | установка вручную<br>manual setup | [httpd_V380_any_manual.zip](https://github.com/Arkady23/V380-Web/releases/download/First-time-installer/httpd_V380_any_manual.zip) |

Для каждой модели камеры с разными Hwname (он же Soft-id) свой установщик. Вы должны знать этот код (или можете использовать вариант установки вручную на любую модель камеры V380), а в некоторых случаях и 7-и значный номер версии прошивки (последнего патча). Но если ошибетесь — ничего страшного... патч будет игнорирован. Никаких изменений в камере не производится. Только обеспечивается запуск командного файла на sd в папке ark-add-on — startup.sh, если этот запускной файл есть на карте. Ваша базовая прошивка может быть самой последней. Вся установка происходит на sd-карту. Если после установки очистить или вынуть sd, то камера будет работать в обычном режиме, как работала до установки. Для подготовки установщика к новым моделям — сообщите её Hwprefix, Hwname и 7-и значный номер версии прошивки. Узнать Hwname и версию можно по трафику с камеры в момент захода на смартфоне в пункт "версия прошивки". Также эту информацию можно увидеть в протоколе загрузки, если вы сможете подключить камеру к последовательному порту. Хорошим способом является обращение в поддержку v380technical(собака)gmail.com для получения последнего обновления от производителя. Последнее обновление можно также скачать самостоятельно с официального ресурса http://update2017.oss-accelerate.aliyuncs.com/..., но для каждой модели своя url-строка и уточнить её опять таки можно только сняв трафик с камеры. Можно определить Hwname, если взять скриншот с экрана смартфона при отображении информации о выходе новой прошивки по её идентификатору. Обучающий ролик, как поймать трафик с камеры https://youtu.be/GLYqb2cC4y0.
### Установка
1. Отформатировать sd-карту в FAT32 ([Вот эта программа](http://ridgecrop.co.uk/index.htm?guiformat.htm) подходит).
#### Для камер с версиями прошивок после 2019 года (установка вручную)
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/download/First-time-installer/httpd_V380_any_manual.zip) в составе:
- ark-add-on
- quick_check.ini
- setup.sh
3. Вставить карту в камеру и включить её... ждать пару минут. Камера включется с запущенным сервером telnet. После чего нужно зайти через telnet по адресу камеры (логин root, пароль посмотреть в файле quick_check.ini).
4. Ввести команду через telnet:<br>
    /mnt/sdcard/setup.sh
5. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
#### Для камер с версиями прошивок до 2019 года
2. Записать в корень карты содержимое [архива](https://github.com/Arkady23/V380-Web/releases/tag/First-time-installer) в составе:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Вставить карту в камеру и включить её... ждать пару минут. Камера должна перезагрузится. После чего можно заходить с помощью обозревателя интернета на адрес камеры. 
### Installation
1. Format the sd card to FAT32 ([Here this program](http://ridgecrop.co.uk/index.htm?guiformat.htm) is suitable).
#### For cameras with firmware versions after 2019 (manual setup)
2. Write to the root of the sd-card the contents of [the archive](https://github.com/Arkady23/V380-Web/releases/download/First-time-installer/httpd_V380_any_manual.zip) as part of:
- ark-add-on
- quick_check.ini
- setup.sh
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera turns on with the telnet server running. After that, you need to log in via telnet to the camera address (login root, password look in the file quick_check.in).
4. Enter command via telnet:<br>
    /mnt/sdcard/setup.sh<br>
5. The camera should reboot. After that, you can use the Internet browser to access the address of the camera. 
#### For cameras with firmware versions up to 2019
2. Write to the root of the sd-card the contents of [the archive](https://github.com/Arkady23/V380-Web/releases/tag/First-time-installer) as part of:
- ark-add-on
- updatepatch
- local_update.conf
- patch_reuse
3. Insert the card into the camera and turn it on... wait a couple of minutes. The camera should reboot. After that, you can use the Internet browser to access the address of the camera.  

![Просмотр основных настроек](screenshots/image_2022_08_21T23_12_43_133Z.png?raw=true)
