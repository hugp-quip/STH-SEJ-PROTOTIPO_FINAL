extends Panel

func crt(ano):
  $Ano.visible = true
  $Ano.text = str(ano)
  $Crt.visible = true
  $Err.visible = false

func err(ano = 0, showb = false):
  if showb:
    $Ano.visible = true
    $Ano.text = str(ano)
  $Err.visible = true
  $Crt.visible = false

func reset():
  $Err.visible = false
  $Ano.visible = false
  $Crt.visible = false
