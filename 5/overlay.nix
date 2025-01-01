self: super: {
  airshipper = super.airshipper.overrideAttrs (old: rec {
    version = 0.9.0
    src = fetchFromGitLab {
        owner = "Veloren";
        repo = "airshipper";
        rev = "v${version}";
	# hash = "sha256-V8G1mZIdqf+WGcrUzRgWnlUk+EXs4arAEQdRESpobGg=";
    };
  });
}
