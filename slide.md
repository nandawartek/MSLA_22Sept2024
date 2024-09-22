---
marp: true
---

# Terraform with Azure
![height:300](./profile.jpeg)
By: Nanda Nugraha
8 Years of exp as Software Eng 

Sekarang lagi kerja di Gov & Founder of ProjectSprint Program


---

## Kenapa si pake terraform? 🤔

Terraform adalah alat yang digunakan untuk mengelola infrastruktur sebagai kode. Dengan menggunakan Terraform, Anda dapat menyusun dan mengelola sumber daya infrastruktur secara **deklaratif**.

---
# Masih belum kebayang mas 😅
![height:300](./tukang.jpg)
Misalnya, bayangkan Terraform sebagai "tukang" dan kamu adalah "arsitek" dari infrastruktur cloud. Kamu pasti akann memberikan instruksi kepada tikang tentang bagaimana membangun infrastruktur yang Anda inginkan, dan tukang akan melakukan tugasnya untuk membangun dan mengelola infrastruktur tersebut.

---

## Cara Setup

Berikut adalah langkah-langkah untuk melakukan setup Terraform:

1. Install terraform cli 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
2. Install azure cli
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
3. Authenicate dengan azure pake `az login`


---

4. ~~Tanya ChatGPT~~ pelajari struktur resource yang ingin dibangun
Karena membangun candi itu tidak sembarangan, perlu planning

Masing-masing cloud provider punya struktur tersendiri untuk mencapai tujuannya, misal
Untuk membuat sebuah VM, Azure butuh:
- Virtual Network (bertanggung jawab atas seluruh koneksi external & internal sistem)
- Subnet (buat membantu assign IP ke resource yg membutuhkan dan isolasi sistem)
- Resource Group (tempat dimana semua resource ditempatkan)
- Public key (buat ssh nya)
- Public IP (buat di akses dari internet)
- Network Interface (Kyk modem / router nya VM)
- Security Group (Yang ngatur NIC cuman boleh dihubungi sm syp aj)

---

## Waktu Demo ✊

---

# Benefit pake terraform
- punya "bird's eye view" terhadap resource apa aja yang kita pake
- bisa di otomasi, duplikat, dan copy ke akun2 lain
- version control: perubahan infrastruktur bisa di-track seperti kode
- konsistensi: mengurangi kesalahan manusia dalam konfigurasi

---

- modularitas: memungkinkan penggunaan ulang komponen infrastruktur
- multi-cloud support: dapat mengelola resource di berbagai provider cloud
- kolaborasi tim: memudahkan kerja sama dalam pengembangan infrastruktur
- testing: memungkinkan pengujian infrastruktur sebelum diterapkan
- dokumentasi sebagai kode: konfigurasi Terraform berfungsi sebagai dokumentasi

--- 
## Paling penting
- efisiensi biaya: memudahkan manajemen dan optimisasi sumber daya


--- 
## Dan itulah kenapa
ProjectSprint bisa nawarin ke temen-temen experience pake cloud dengan harga yang murah meriah, karena **aku terbantu dengan terraform untuk mengetahui resource apa aja yang aku pake**

Sehingga aku bisa dengan bijak menentukan apa yang aku butuhkan, dan menekan biaya nya jauh lebih kuat

--
Open Registrasi 22:00
### projectsprint.dev 🚀