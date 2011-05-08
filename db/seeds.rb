# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


require 'csv'


'Ayuda al desarrollo
Ciencia e Innovación
Contratación Pública
Cultura
Deporte
Economía
Educación
Energía
Estadística
Información Local
Justicia
Mapas
Medio Ambiente
Meteorología
Obra pública
Política
Tráfico y transporte
Turismo'.split("\n").each do |category_name|
Category.find_or_create_by_name(category_name)
end


csv = CSV.parse(`curl 'http://www.aporta.es/BuscadorCatalogos/descarga.jsp' | iconv -f iso-8859-15 -t UTF-8`, ";")
csv.shift
# 0 - Num.Registro
# 1 - Titulo
# 2 - Organismo Responsable
# 3 - Direccion Web
# 4 - Organismo Editor
# 5 - Clase Info
# 6 - Formato Presentacion
# 7 - Tipo Info
# 8 - Tipo Consulta
# 9 - Materia
# 10 - Descripcion

csv.each do |aporta_source|
  source = Source.find_by_title(aporta_source[1]) || Source.new(aporta_source[1])
  source.source_type = aporta_source[6]
  source.title = aporta_source[1]
  source.url = aporta_source[3]
  more_info = {
    "Organismo Responsable" => aporta_source[2],
    "Organismo Editor" => aporta_source[4],
    "Clase Info" => aporta_source[5],
    "Tipo Info" => aporta_source[7],
    "Tipo Consulta" => aporta_source[8],
    "Materia" => aporta_source[9],
    "Extraido" => "Proyecto Aporta: http://www.aporta.es"
  }

  more_info = more_info.map {|k,v|  "#{k}\n#{'='*k.size}\n#{v}\n\n"  }.join("")
  source.description = aporta_source[10]+"\n\n\n"+more_info

  source.save
end


