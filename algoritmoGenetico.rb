#!/usr/bin/env ruby
# encoding: utf-8
# Programa: algoritmoGenetico.rb
# Autor: David Andres Ramirez
# Email: david.andres.ramirez@correounivalle.edu.co
# Fecha creación: 2019-03-17 
# Fecha última modificación: 2019-04-4
# Versión: 0.1
# Licencia: 
# 	 This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
############################################################
# Utilidad: Definicion de las clases principales para el proyecto de computación 
# evolutiva 
############################################################
# VERSIONES
# 0.1 La primera. 
############################################################
# Se trata de modelar el cromosoma que se usara para el proyecto
############################################################


require 'rubygems'
require 'bundler/setup' 
require 'matrix'

#Definicion de la clase cromosoma
class Cromosoma < Array 
	
  #Se utiliza attr_accessor para definir de forma automatica los set y get de 
  #la variable aptitud
  attr_accessor :aptitud
  
  #Constructor de la clase
  #Recibe un tamaño y crear un array de enteros que no se repiten
  #se debe verificar que sea mayor o igual a 4 por que para menos de 4 no tiene sentido
  def initialize(tamano)
	super
    @tamano = tamano
	self.replace ((0..(tamano -1)).to_a.shuffle.take(tamano)) 
	
	
	#este metodo se salta aveces un valor
	#(0..(tamano -1)).to_a.shuffle.take(tamano)#Truco para generar secuencias aleatorias y unicas en ruby 
	#nuevo metodo
	#self << (0..(tamano-1)).to_a.sample(tamano)
	
  end
  
  # Funcion Mutar:
  # Realiza la mutación del cromosoma, recibe un numero entre 1 y 3 que indica cuanto del cromosoma mutar
  # con el valor de 3.0 se mutara levemente el cromosoma , con el valor de 2.0 se mutara considerablemente el cromosoma y 
  # con el valor de 1.0 se mutara todo le cromosoma, por defecto se recomienda mutarlo poco
  
  def Mutar (porcentaje)
	
	if porcentaje >= @tamano 
	
		puts "No puede tener un valor mas igual o mas grande que el tamaño del arreglo"
	else
		 
		valormutar = (@tamano / porcentaje).ceil
		
		
		
		if (valormutar <= 1) || (valormutar % 2 == 1)
			valormutar = valormutar+1
		end
		
		if porcentaje == 1
			
			indicedearranque = 0
		
		else
			indicedearranque = rand((@tamano-1) - valormutar)
		end
		
		#puts "el valor de mutación es"
		#puts valormutar
		#puts "el valor random es"
		#puts indicedearranque
		
			
		i = 1
		while i <= valormutar 
			
			if indicedearranque == (@tamano-1)
				
				valorTemp = self[indicedearranque]
				self[indicedearranque] = self[0]
				self[0] = valorTemp
				i+=2
				
			else
				valorTemp = self[indicedearranque]
				self[indicedearranque] = self[indicedearranque+1]
				self[indicedearranque+1] = valorTemp
				indicedearranque = indicedearranque+2
				i+=2
			end
		end
	end
	
	self.calcularActitud()
	
	

  end
  
  #Función Cruce: 
  #Realiza el cruce uniforme del cromosoma- no se va a usar pero se debe implementar
  #El cruce se realiza curzando elementos de cada cromosoma de una forma "aleatoria"
  #dependiendo de un valor aleatorio se cruza o no un cromososma.
  
  ## IMPORTANTE: Esta funcion debe usarse con apoyo de la clase donde se realice el 
  #cambio de generaciones, es decir se debe manejar en la clase Genetic si se desea usar
  def Cruce (cromosomaDeCruce)
	
	##Se cruzan los cromosomas 
	 cromosomaResultado = Cromosoma.new(@tamano)
		self.each_with_index do |value , index| 
			
			posibilidad = rand(0..1)
				
			if posibilidad == 1 then
					cromosomaResultado[index] = self[index]
					
   			else
					cromosomaResultado[index] = cromosomaDeCruce[index]
						
			end
								
		end
		
	return cromosomaResultado
  
  end
  
  ##Funcion encargada de sacar las diagonales principales
  #| X |   | 
  #|   | X |  
   def calcularDiagonalPrincipal (indice, valor)
	 valores = Array.new
	 indices = Array.new
	 	 
	 indicefor = indice
	 valorfor  = valor
		
		##Se calculan los valores diagonales hacia adelante
		while (indicefor <= (@tamano-1) && valorfor <= (@tamano-1))  do
			indices << indicefor
			valores << valorfor
			indicefor +=1
			valorfor  +=1
			
		end
		
		##Se calculan los valores diagonales hacia atras
		indicesnew = Array.new
		valoresnew = Array.new
		indicefor = indice-1
		valorfor  = valor-1
		while (indicefor >= 0 && valorfor >= 0)  do
			indicesnew << indicefor
			valoresnew << valorfor
			indicefor -=1
			valorfor  -=1
			
		end
		
		matriz = Matrix[indicesnew.reverse + indices, valoresnew.reverse + valores]
				
		# matris [filas (0 para indices- 1 para valores) , columnas son valores(valor inicial...valor final)]
		# ejemplo : puts matriz[0,5]
		return matriz
  
  
  end
  
  ##Funcion encargada de sacar las diagonales secundarias
  #|   | X | 
  #| X |   |  
   def calcularDiagonalSecundaria (indice, valor)
	 indices = Array.new
	 valores = Array.new
	 
	 indicefor = indice
	 valorfor  = valor
		
		##Se calculan los valores diagonales hacia adelante
		while (indicefor <= (@tamano-1) && valorfor >= 0)  do
			
			indices << indicefor
			valores << valorfor
			indicefor +=1
			valorfor  -=1
			
		end
		
		##Se calculan los valores diagonales hacia atras
		valoresnew = Array.new
		indicesnew = Array.new
		indicefor = indice-1
		valorfor  = valor+1
		while (indicefor >= 0 && valorfor <= (@tamano-1))  do
			
			indicesnew << indicefor
			valoresnew << valorfor
			indicefor -=1
			valorfor  +=1
			
		end
		matriz = Matrix[indicesnew.reverse + indices, valoresnew.reverse + valores]
		return matriz
  end
  
  
  
  ##Funcion calcularActitud
  #retorna la actitud de el cromosoma detectando sus ataques diagonales
  def calcularActitud
	
	@aptitud = 0
	
	self.each_with_index do |item, index|	
			
				principalTemp = calcularDiagonalPrincipal(index, item)
				secondaryTemp = calcularDiagonalSecundaria(index, item)
				#puts "principal es #{principalTemp}"
				
				#puts "secundario es #{secondaryTemp}"	
				
				principalTemp.row(0).each_with_index do |value , newindex|
				
					if (self[value] == principalTemp.row(1)[newindex] && index != value)
						
						@aptitud -=1
						
					end
								
				end
				
				secondaryTemp.row(0).each_with_index do |value , newindex|
					
					if (self[value] == secondaryTemp.row(1)[newindex] && index != value)
						@aptitud -=1
					end
								
				end
	end
    
  end

end





#Definicion de la clase Genetic que se encarga de la funcionalidad
class Genetic < Array 

	#Constructor de la clase
	#Recibe un numero de cromosomas y los crea 
	def initialize(cromosomas,tamano)
			
		@numeroCromosomas = cromosomas
		@tamano = tamano
		
		for counter in 1..@numeroCromosomas
			cromtemp = Cromosoma.new(tamano)
			cromtemp.calcularActitud()
			self << cromtemp
		end

	end
		
	#funcion ejecutar que se encarga de la ejecución del proyecto
	def Ejecutar(mejores,mutacion)
		candidato = nil
		i = 0
		hayCandidato = false
		
		while  hayCandidato == false  do
	
		##Se muta todos los cormosomas
		#realizar mutación
			self.each_with_index do |item, index|				
				if (item.aptitud == 0 )
					hayCandidato = true
						puts "HAYY CANDIDATO--------------------"
						puts "con la aptitud: #{item.aptitud}" 
						p item	
						puts "con la generacion #{i}"
						candidato = item	
						break if hayCandidato == true				
				end
				
				item.Mutar(mutacion)
					
			end
		##Se evaluan los cromosomas y pasa el (o los) de mayor aptitud
		##estos pasan al siguiente generacion
		##si la aptitud llega a 0 se para
		
		## para estudiar la aptitud se ordenan los cromosomas usando el parametro ptitud
		
			temp = self.sort_by(&:aptitud).reverse
			
			self.replace(temp)
				
			##se crea la nueva generación con los n mejores de la anterior y nuevos
			faltantes = @numeroCromosomas - mejores
			
			
			nuevaGeneracion = self.take(mejores)
				
			
			
			for counter in 0..faltantes-1	
			    temp = 	Cromosoma.new(@tamano)
			    temp.calcularActitud()
				nuevaGeneracion << temp	
			end		
					
			self.replace(nuevaGeneracion)


		i +=1
		end	
		
		#este return es ayuda para los testers
		return candidato
	end
	
	#Funcion Ejecutar con variedad:
	#esta funcion realiza la seleción de la nueva generación por medio del (los) cromosomas mas variados
	#siendo estos los que pasen a la siguiente generación
	#Para saber cuales son los cromososmas mas variados se usa la aptitud se eliminan 
	#los que tengan aptitudes iguales, pero siempre se deja uno para no eliminar a todos los peores
    
    def EjecutarVariedad(mutacion)
		
		candidato = nil
		i = 0
		hayCandidato = false
		
		while  hayCandidato == false  do
	
			##Se muta todos los cormosomas
			#realizar mutación
			self.each_with_index do |item, index|
				
				
				if (item.aptitud == 0 )
					hayCandidato = true
						puts "HAYY CANDIDATO--------------------"
						puts "con la aptitud: #{item.aptitud}" 
						p item	
						puts "con la generción #{i}"
						break if hayCandidato == true					
				end
				
				item.Mutar(mutacion)
					
			end
			##Se evaluan los cromosomas y pasa el (o los) de  aptitud mas lejana
			##estos pasan al siguiente generacion
			##si la aptitud llega a 0 se para
			
			## para estudiar la aptitud se ordenan los cromosomas usando el parametro aptitud
		
			temp = self.sort_by(&:aptitud).reverse
			
			self.replace(temp)
					
			#Se utiliza un hash para guardar el indice de inicio
			distancias = Hash.new
			
			#este array se usar como ayuda para eliminar los repetidos del hash
			arr = Array.new
			
			#se calcula la distancia entre las aptitudes de cada cromosoma
			# por ejemplo en el indice 0 de el array distancias sera la istancia entr el cromosoma 0 y 1
			
			self.each_with_index do |item, index|
				
				
					if (index < (self.length - 1 ))
					
						distanciaDerecha = self[index+1].aptitud.abs - item.aptitud.abs
					
						distancias.store(index , distanciaDerecha )
					end	
					
			end
			
			#aqui sacamos lo unicos con sus indices ayudado de un hash
			unicos = distancias.each{|key, val| arr.include?(val) ? distancias.delete(key) : arr << val }
			
			
			#aqui ordenamos el hash para sacar las mayores distancias
			unicosSort = Hash[(unicos.sort_by { |name, age| age }).reverse]
			
			
			#Ahora transformo en los cromosomas que lo representan y y los paso como los mejores en la nueva generacion
			
			nuevaGeneracion = Array.new
			
			unicosSort.keys.each do |item|
				
				nuevaGeneracion << self[item]		
				
					
			end
	
			faltantes = @numeroCromosomas - nuevaGeneracion.length
			##se crea la nueva generación con los n mejores de la anterior y nuevos
			
			for counter in 0..faltantes-1	
			    temp = 	Cromosoma.new(@tamano)
			    temp.calcularActitud()
				nuevaGeneracion << temp	
			end		
					
			self.replace(nuevaGeneracion)

		
		i +=1
		end	
		
		#este return es ayuda para los testers
		return candidato
    
    
    
    end
 

	#Funcion Ejecutar con variedad pero solo eliminando las aptitudes repetidas:
	#esta funcion realiza la seleción de la nueva generación por medio del (los) cromosomas mas variados
	#siendo estos los que pasen a la siguiente generación
	#Para saber cuales son los cromososmas mas variados se usa la aptitud se eliminan 
	#los que tengan aptitudes iguales, pero siempre se deja uno para no eliminar a todos los peores  
    
	def EjecutarVariedadRepetidos(mutacion)
			candidato = nil
			i = 0
			hayCandidato = false
			
			while  hayCandidato == false  do
		
				##Se muta todos los cormosomas
				#realizar mutación
				self.each_with_index do |item, index|
					
					
					if (item.aptitud == 0 )
						hayCandidato = true
							puts "HAYY CANDIDATO--------------------"
							puts "con la aptitud: #{item.aptitud}" 
							p item	
							puts "con la generción #{i}"
							break if hayCandidato == true					
					end
					
					item.Mutar(mutacion)
						
				end
				##Se evaluan los cromosomas y pasa el (o los) de  aptitud mas lejana
				##estos pasan al siguiente generacion
				##si la aptitud llega a 0 se para
				
				## para estudiar la aptitud se ordenan los cromosomas usando el parametro aptitud
			
				temp = self.sort_by(&:aptitud).reverse
				
				self.replace(temp)
						
				
				#eliminamos a los que tengan aptitudes repetidas y los otros los pasamos a la nueva generacion
				
				nuevaGeneracion =  self.uniq {|obj| obj.aptitud}
				
								
				faltantes = @numeroCromosomas - nuevaGeneracion.length #se determinan los faltantes
				##se crea la nueva generación con los n mejores de la anterior y nuevos

				

				for counter in 0..faltantes-1	
					temp = 	Cromosoma.new(@tamano)
					temp.calcularActitud()
					nuevaGeneracion << temp	
				end		
						
				self.replace(nuevaGeneracion)

			
			i +=1
			end	
			
		
		#este return es ayuda para los testers
		return candidato
		
		
	end
	
	#fundion EjecutarMixed: 
	#esta funcion esta encargada de ejecutar utilizando como funcion aptitud una mezcla entre 
	#pasar las mas variables y las mejores
	#Nosostros lo que haremos es escoger los mejores cromosomas, y de esos escoger los mas variables por 
	#el metodo de las aptitudes repetidas
	def EjecutarMixed(mejores,mutacion)
		candidato = nil
		i = 0
		hayCandidato = false
		
		while  hayCandidato == false  do
	
		##Se muta todos los cormosomas
		#realizar mutación
			self.each_with_index do |item, index|
				##puts "se muta cromosoma: #{index}"
				
				if (item.aptitud == 0 )
					hayCandidato = true
						puts "HAYY CANDIDATO--------------------"
						puts "con la aptitud: #{item.aptitud}" 
						p item	
						puts "con la generacion #{i}"	
						break if hayCandidato == true					
				end
				
				item.Mutar(mutacion)
					
			end
		##Se evaluan los cromosomas y pasa el (o los) de mayor aptitud
		##estos pasan al siguiente generacion
		##si la aptitud llega a 0 se para
		
		## para estudiar la aptitud se ordenan los cromosomas usando el parametro ptitud
		
			temp = self.sort_by(&:aptitud).reverse
			
			self.replace(temp)
				
			##se crea la nueva generación con los n mejores de la anterior y nuevos
			
			nuevaGeneracionMejores = self.take(mejores) #se toman los mejores
			
			##AQUI se aplica el filtro por aptitudes repetidas
				
			nuevaGeneracion =  nuevaGeneracionMejores.uniq {|obj| obj.aptitud}
									
			faltantes = @numeroCromosomas - nuevaGeneracion.length
			
			for counter in 0..faltantes-1	
			    temp = 	Cromosoma.new(@tamano)
			    temp.calcularActitud()
				nuevaGeneracion << temp	
			end		
					
			self.replace(nuevaGeneracion)

		i +=1
		end	
		
		#este return es ayuda para los testers
		return candidato
	end
	
	
end


#Clase encargada de desplegar un menu
#se realiza en una clase aparte para hacer mas versatil el programa
class MenuWrapper
	
	def initialize
		
	end

	#Funcion menuEjecutar.
	#esta funcion es un pequeño menu para el usuario final
	def menuEjecutar
		
		sol = Array.new
		
		puts "------------BIENVENIDO A N-REINAS-EVOLUTIVO---------------\n\n"
		
		#puts "El resultado se guardara en un archivo llamado solucion.txt\n"
		
		puts "-------------------------MENU-----------------------------\n\n"
		
		puts "Ingresa el numero de cromosomas para trabajar"
		numcromosomas = gets.chomp.to_i
		
		if numcromosomas < 2 
			puts "deben ser mas de 2 cromosomas, por defecto te asignaremos 4"
			numcromosomas = 4
		end
		puts "Ingresa el tamaño que tendran los cromosomas"
		tama = gets.chomp.to_i
		if tama < 4 
			puts "se recomienda que el tamaño de los cromosomas sean mayor que 3
			\n te asiganremos por defecto el tamaño 4"
			tama = 4
		end
		
		puts "Ingresa el porcentaje de mutacion entre 1 y 3"
		muta = gets.chomp.to_i
		
		if muta > 3 || muta < 1
			puts "deben ser un valor entero entre 1 y 3, te asignaremos 3 por defecto que muta poco"
			muta = 3
		end
		
		hi = Genetic.new(numcromosomas,tama)
		
		valido = false
		
		while valido == false
		
			
			puts "Selecione una funcion objetivo de las siguiente usando numeros del 1 al 4
			\n 1 -> pasan los de mejor aptitud
			\n 2 -> pasan los mas variados por distancia entre aptitudes
			\n 3 -> pasan los mas variados por metodos de las aptitudes no repetidas
			\n 4 -> pasan los de mejor aptitud y mas variables por aptitudes no repetidas"
			 option = gets.chomp.to_i
			if option <= 4
			 valido = true
			end
		end
		
		case option
			when 1
			  puts "Ingrese la cantidad de los mejores que pasan"
			  cantidadMejores = gets.chomp.to_i
			  
			  if cantidadMejores >= numcromosomas
				puts "Nu pueden pasar todos los cromosomas, eso no es interesante :("
				
				puts "por defecto tomaremos la mitad de los cromosomas"
				
				
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.Ejecutar((numcromosomas / 2).ceil , muta)
				
				
			  else 
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.Ejecutar(cantidadMejores, muta)
				
			  end
			  
			  
			  
			when 2
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.EjecutarVariedad(muta)
			when 3
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.EjecutarVariedadRepetidos(muta)
			when 4
			  puts "Ingrese la cantidad de los mejores que pasan"
			  cantidadMejores = gets.chomp.to_i
			  
			  if cantidadMejores >= numcromosomas
				puts "Nu pueden pasar todos los cromosomas, eso no es interesante :("
				
				puts "por defecto tomaremos la mitad de los cromosomas"
				
				
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.EjecutarMixed((numcromosomas / 2).ceil, muta)
				
				
			  else 
				puts "se inicia la ejecución...se recomienda ir por un tinto"
				sol=hi.EjecutarMixed(cantidadMejores,muta)
				
			  end
			else
			  puts "Se nos ha escapado una opción no valida :("
		end
	
		puts "desea ver una representacion grafica de la solución? Y/N"
		graph = gets.chomp
		puts "------------------------------------------------------------"
		
		if graph == 'Y' || graph == 'y'
			haciaAdelante=0
			
			
			
			
			sol.each_with_index do |item, index| 
				stringGenerate = '|0'*sol.length + '|'
				stringShow = stringGenerate
				
				stringShow[(item*2)+1]='X'
				
				puts stringShow
				
	
			end
			
			
		end
	end
	
	
end

#hi = Genetic.new(100,5)
menu = MenuWrapper.new()
#hi.Ejecutar(1,1)
menu.menuEjecutar
#puts hi


