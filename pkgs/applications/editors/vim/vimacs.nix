{ stdenv, vim, vim_configurable, vimPlugins }:

stdenv.mkDerivation rec {
  name = "vimacs-${vimPlugins.vimacs.version}";

  buildInputs = [ vim vim_configurable vimPlugins.vimacs ];

  buildCommand = ''
    mkdir -p "$out"/bin
    cp "${vimPlugins.vimacs}"/share/vim-plugins/vimacs/bin/vim $out/bin/vimacs
    substituteInPlace "$out"/bin/vimacs \
      --replace '-vim}' '-@bin@/bin/vim}' \
      --replace '-gvim}' '-@bin@/bin/gvim}' \
      --replace '--cmd "let g:VM_Enabled = 1"' \
                '--cmd "let g:VM_Enabled = 1" --cmd "set rtp^=@rtp@"  -c "set nopaste" -c "inoremap <C-c> <C-l>"' \
      --replace @rtp@ ${vimPlugins.vimacs.rtp} \
      --replace @bin@ ${vim_configurable}
    for prog in vm gvm gvimacs vmdiff gvmdiff vimacsdiff gvimacsdiff
    do
      ln -s "$out"/bin/vimacs $out/bin/$prog
    done
  '';

  meta = with stdenv.lib; {
    description = "Vim-Improved eMACS: Emacs emulation for Vim";
    homepage = "http://algorithm.com.au/code/vimacs";
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ millerjason ];
  };
}
