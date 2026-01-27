# Electronic Code Book

|Lab | Kategori | Kesulitan|
| :-- | :---- | :---- |
| [Kepengin jadi admin](https://www.pwnthe.website/labs/b5c91feb-50a4-409e-b79c-e751f8156a85) | Cryptography | Medium

## Teori
Electronic Code Book (ECB) adalah metode enkripsi di mana *pesan* dipecah menjadi beberapa blok berukuran X byte dan setiap blok dienkripsi secara independen menggunakan *kata kunci.*
Yang jadi problem adalah, ***karena setiap blok dienkripsi secara independen, maka polanya masih tetap terbaca.***

Anggaplah setiap piksel foto Reze dienkripsi menggunakan ECB, maka hasilnya:
![https://i.ibb.co.com/8TLfv4W/ascii-art.webp](https://i.ibb.co.com/8TLfv4W/ascii-art.webp)

Masih terlihat, ngga?

## Studi Kasus

### Analisa
Oke, di sini ada sebuah web aplikasi di mana saya membuat akun dengan kredensial test:test.
![web app](https://i.ibb.co.com/LX0tH9tD/image.png)
Token yang tersimpan pada cookies: `session:%2F7cDJ6Z81blSkOw9GDUTdA%3D%3D`.

Ketika saya relogin, token-nya masih sama: `session:%2F7cDJ6Z81blSkOw9GDUTdA%3D%3D`.

Rule of thumb: **jika token yang diberikan selalu sama dalam autentikasi, maka hukumnya wajib untuk diselidiki.**

Token di atas dienkripsi menggunakan base64 dan di-url-encoding.

Saya membuat akun baru dengan kredensial testtest:testtest, dan cookies-nya: `session:%2FSODinicUi%2BAVSfPDFmB0bOrtQLs%2BJMVX8bOTrJH3RA%3D`

Loh, makin panjang?

Token pada cookies pertama ketika dicek panjang byte-nya dengan perintah:
```
echo -n '%2F7cDJ6Z81blSkOw9GDUTdA%3D%3D' | urlencode -d | base64 -d | wc -c
```
Hasilnya 16 byte.

Token kedua:
```
echo -n '%2FSODinicUi%2BAVSfPDFmB0bOrtQLs%2BJMVX8bOTrJH3RA%3D' | urlencode -d | base64 -d | wc -c
```
Hasilnya 32 byte.

Percobaan terakhir, saya membuat akun dengan username `AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA` (32xA) untuk menganalisa cookies-nya.
![](https://i.ibb.co.com/Dgf5NFkj/image.png)

Tanda asterix (*) pada blok kedua menandakan bahwa nilainya sama dengan blok pertama.
Ini adalah indikasi kuat bahwa cookie user dienkripsi menggunakan electronic code book, yang panjang setiap bloknya adalah 16 byte.

Dari informasi tersebut juga, kita bisa mengira-ngira format plaintext-nya, antara `username-delimiter-password` atau `usernamepassword`.

### Eksploitasi
Cara untuk masuk ke akun `admin` kita harus mendapatkan cookies-nya. Seperti yang dijelaskan pada [Teori](#teori), karena hasil
enkripsi ECB dapat kita baca polanya, kita bisa ***memodifikasi pesan terenkripsi tanpa perlu tau plaintextnya***.
Caranya:
1. Buat akun baru dengan tambahan 16 karakter di depannya. misal: `xxxxxxxxxxxxxxxxadmin:test`
2. Cookies-nya `E4NVVGpu0i%2Bh1Nr8Y3OREiscwMognm5gqsaNInPUfBc%3D`
3. `echo -n 'E4NVVGpu0i%2Bh1Nr8Y3OREiscwMognm5gqsaNInPUfBc%3D' | urlencode -d | base64 -d | tail -c +17 | base64 | urlencode` perintah ini berarti mendecode cookie, mengambil byte ke-17 sampai akhir yang berarti membuang 1 blok pertama yang berukuran 16 byte, yang dalam hal ini `xxxxxxxxxxxxxxxx` lalu men-encode kembali agar sesuai format cookies-nya.
4. hasilnya `KxzAyiCebmCqxo0ic9R8Fw%3d%3d%0a`
5. Ubah nilai cookie asli di devtools, lalu refresh.
![](https://i.ibb.co.com/Y4PWzTm5/image.png)

Berhasil masuk ke akun admin!
