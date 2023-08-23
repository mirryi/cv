FROM frolvlad/alpine-glibc:alpine-3.15_glibc-2.33 as build
WORKDIR /tmp/install-tl-unx

# hadolint ignore=DL3018
RUN apk --no-cache add perl wget xz tar \
  && wget --progress=dot:giga https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
  && tar --strip-components=1 -xvf install-tl-unx.tar.gz \
  && printf "%s\n" \
  "TEXDIR /opt/texlive" \
  "TEXMFLOCAL /opt/texlive/texmf-local" \
  "TEXMFSYSCONFIG /opt/texlive/texmf-config" \
  "TEXMFSYSVAR /opt/texlive/texmf-var" \
  "TEXMFHOME ~/.local/share/texlive/texmf" \
  "TEXMFCONFIG ~/.local/share/texlive/texmf-config" \
  "TEXMFVAR ~/.local/share/texlive/texmf-var" \
  "selected_scheme scheme-minimal" \
  "binary_x86_64-linux 1" \
  "collection-basic 1" \
  "option_adjustrepo 1" \
  "option_autobackup 1" \
  "option_backupdir tlpkg/backups" \
  "option_desktop_integration 1" \
  "option_doc 0" \
  "option_file_assocs 1" \
  "option_fmt 1" \
  "option_letter 0" \
  "option_path 1" \
  "option_post_code 1" \
  "option_src 0" \
  "option_sys_bin /opt/bin" \
  "option_sys_info /opt/info" \
  "option_sys_man /opt/man" \
  "option_w32_multi_user 1" \
  "option_write18_restricted 1" \
  "portable 0" \
  > texlive.profile \
  && ./install-tl --profile=texlive.profile \
  && apk del xz tar
ENV PATH="/opt/texlive/bin/x86_64-linux:${PATH}"

# hadolint ignore=DL3018
RUN apk --no-cache add make \
  && tlmgr update --self \
  && tlmgr update --list \
  && tlmgr install collection-latex latexmk enumitem titlesec xkeyval \
       fontaxes libertinus libertinus-type1 etoolbox

WORKDIR /build
COPY Makefile latexmkrc resume.tex preamble.tex ./
RUN make

FROM scratch as export
WORKDIR /
COPY --from=build /build/resume.pdf .
