resource "yandex_compute_disk" "disk" {
  name = "disk-${count.index + 1}"
  size = 1

  zone = "ru-central1-a"

  count = 3
}