# frozen_string_literal: true

module CodeTemplate
  def tailwind_import
    "@import '~/styles/tailwind';\n@import 'tailwindUi/global.scss';\n"
  end

  def join_path_import
    "import { join } from 'path';"
  end

  def package_dir_const
    "const tailwindUiDir = join(__dirname, '../tailwind_ui');"
  end

  def resolve_alias
    'tailwindUi: tailwindUiDir,'
  end

  def server_fs_allow
    'tailwindUiDir,'
  end
end
