resource "yandex_alb_http_router" "http_router" {
  name = "http-router"
    match {
      path_prefix = "/"
    }
    action {
      target_group {
        name = yandex_lb_target_group.web_target_group.name
      }
    }
  }
}
resource "yandex_alb" "http_alb" {
  name = "http-alb"

  listener {
    name          = "http-listener"
    external_port = 80
    protocol      = "HTTP"

    default_target_group = yandex_lb_target_group.web_target_group.name
  }

  rule {
    name    = "http-rule"
    router  = yandex_lb_http_router.http_router.name
    path    = "/"
  }
}

output "load_balancer_ip" {
  value = yandex_lb_application_load_balancer.http_alb.external_ipv4_address
}
