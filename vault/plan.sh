pkg_origin=dbhagen
pkg_name=vault
pkg_version=0.10.2
pkg_description="A tool for managing secrets."
pkg_maintainer='The Habitat Maintainers <humans@habitat.sh>'
pkg_license=("MPL-2.0")
pkg_upstream_url=https://www.vaultproject.io/
pkg_source=https://releases.hashicorp.com/vault/${pkg_version}/vault_${pkg_version}_linux_amd64.zip
pkg_shasum=f725be68316d10ef2e7779fdedd8eb5d4ed9975303c828466bb9a729e01392dd
pkg_filename=${pkg_name}-${pkg_version}_linux_amd64.zip
pkg_deps=(core/cacerts)
pkg_build_deps=(core/unzip)
pkg_bin_dirs=(bin)
#pkg_svc_user=root
#pkg_svc_group=root
pkg_exports=(
  [port]=listener.port
)
pkg_exposes=(port)

do_unpack() {
  cd "${HAB_CACHE_SRC_PATH}" || exit
  unzip ${pkg_filename} -d "${pkg_name}-${pkg_version}"
}

do_build() {
  return 0
}

do_install() {
  install -D vault "${pkg_prefix}"/bin/vault 2>&1
  chown -R "${pkg_svc_user}":"${pkg_svc_group}" "${pkg_prefix}" 2>&1
  chown -R "${pkg_svc_user}":"${pkg_svc_group}" "${pkg_svc_data_path}" 2>&1

  ### Prep for an UGLY way to fix Vault's dependancy on Root CAs being present. See Run Hook.
  cp "$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem" "${pkg_svc_data_path}/cacert.pem" 2>&1
}
