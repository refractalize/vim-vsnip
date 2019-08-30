"
" Replace buffer text.
"
" @param vim_range - start: inclusive, end: exclusive
"
function! snips#utils#edit#replace_buffer(vim_range, lines)
  let l:range_len = a:vim_range['end'][0] - a:vim_range['start'][0] + 1
  let l:lines_len = len(a:lines)

  let l:start_line = getline(a:vim_range['start'][0])
  let l:start_line_before = a:vim_range['start'][1] > 1 ? l:start_line[0 : a:vim_range['start'][1] - 2] : ''
  let l:end_line = getline(a:vim_range['end'][0])
  let l:end_line_after = a:vim_range['end'][1] <= strlen(l:end_line) ? l:end_line[a:vim_range['end'][1] - 1 : -1] : ''

  let l:i = 0
  while l:i < l:lines_len
    " create text.
    let l:text = ''
    if l:i == 0
      let l:text .= l:start_line_before
    endif
    let l:text .= a:lines[l:i]
    if l:i == l:lines_len - 1
      let l:text .= l:end_line_after
    endif

    " change or append.
    let l:lnum = a:vim_range['start'][0] + l:i
    if l:lnum <= a:vim_range['end'][0]
      call setline(l:lnum, l:text)
    else
      call append(l:lnum - 1, l:text)
    endif

    let l:i += 1
  endwhile

  " remove.
  let l:i = l:lines_len
  while l:i < l:range_len
    call deletebufline('%', a:vim_range['start'][0] + l:lines_len)
    let l:i +=1
  endwhile
endfunction

"
" Replace text.
"
" @param vim_range - start: inclusive, end: exclusive
"
function! snips#utils#edit#replace_text(target, vim_range, lines)
  let l:target = a:target
  let l:range_len = a:vim_range['end'][0] - a:vim_range['start'][0] + 1
  let l:lines_len = len(a:lines)

  let l:start_line = l:target[a:vim_range['start'][0] - 1]
  let l:start_line_before = a:vim_range['start'][1] > 1 ? l:start_line[0 : a:vim_range['start'][1] - 2] : ''
  let l:end_line = l:target[a:vim_range['end'][0] - 1]
  let l:end_line_after = a:vim_range['end'][1] < strlen(l:end_line) ? l:end_line[a:vim_range['end'][1] - 1 : -1] : ''

  let l:i = 0
  while l:i < l:lines_len
    " create text.
    let l:text = ''
    if l:i == 0
      let l:text .= l:start_line_before
    endif
    let l:text .= a:lines[l:i]
    if l:i == l:lines_len - 1
      let l:text .= l:end_line_after
    endif

    " change or append.
    let l:lnum = a:vim_range['start'][0] + l:i
    if l:lnum <= a:vim_range['end'][0]
      let l:target[l:lnum - 1] = l:text
    else
      call insert(l:target, l:text, l:lnum - 1)
    endif

    let l:i += 1
  endwhile

  " remove.
  let l:i = l:lines_len
  while l:i < l:range_len
    call remove(l:target, a:vim_range['start'][0] + l:lines_len - 1)
    let l:i +=1
  endwhile

  return l:target
endfunction

"
" Select or insert start.
"
" @param vim_range - start: inclusive, end: exclusive
"
function! snips#utils#edit#select_or_insert(vim_range)
  if snips#utils#range#has_length(a:vim_range)
    call cursor(a:vim_range['end'])
    normal! hgh
    call cursor(a:vim_range['start'])
  else
    call cursor(a:vim_range['start'])
    startinsert
  endif
endfunction

