admins = { "admin@localhost" }

use_libevent = false
daemonize = false
certificates = "certs"
pidfile = "/var/run/prosody/prosody.pid"

Include "conf.d/modules.cfg.lua"
Include "conf.d/logging.cfg.lua"

ssl = {
  key = "/etc/prosody/certs/localhost.key";
  certificate = "/etc/prosody/certs/localhost.crt";
}

allow_registration = false
c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = true
s2s_insecure_domains = { }
s2s_secure_domains = { }
cross_domain_bosh = true
cross_domain_websocket = true
-- consider_websocket_secure = false
authentication = "internal_hashed"
default_storage = "internal"

-- storage = { }
-- sql = ""
storage = "sql"
sql = {driver = "SQLite3", database = "prosody.sqlite"}

archive_expires_after = "1w" -- Remove archived messages after 1 week

VirtualHost "localhost"

Include "vhost.d/*.cfg.lua"