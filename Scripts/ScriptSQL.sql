CREATE DATABASE DB_GestorNotas
GO

USE DB_GestorNotas
GO

/*CREACION DE TABLAS*/
GO

--TABLA Alumnos*/
CREATE TABLE Alumnos(
    nIdAlumno  INT NOT NULL IDENTITY(1,1) PRIMARY KEY ,
    sCodAlu    CHAR(10),
	  sNombres   VARCHAR(50),
    sApellidos VARCHAR(50),
    nEdad INT
)
GO

--TABLA Cursos
CREATE TABLE Cursos(
    nIdCurso  INT NOT NULL IDENTITY(1,1) PRIMARY KEY ,
    sCodCur   CHAR(10),
	  sNomCur   VARCHAR(50),
    nCreditos INT
)
GO

--TABLA Alumnos por Curso (Notas)
CREATE TABLE Alu_Cur(
  nIdAluCur INT NOT NULL IDENTITY(1,1) PRIMARY KEY ,
  nIdAlumno INT,
	FOREIGN KEY (nIdAlumno) REFERENCES Alumnos(nIdAlumno),
	nIdCurso  INT,
  FOREIGN KEY (nIdCurso) REFERENCES Cursos(nIdCurso),
	nNota     INT
)
GO

/*CREACION DE FUNCIÓN*/
GO

CREATE FUNCTION [dbo].[Split] (@String nvarchar (4000), @Delimitador nvarchar (10)) 
                returns @ValueTable table ([id] int,[valor] nvarchar(4000))
begin
	DECLARE @NextString nvarchar(4000)
	DECLARE @Pos int
	DECLARE @NextPos int
	DECLARE @CommaCheck nvarchar(1)
	DECLARE @nFila INT = 1

	--Inicializa
	SET @NextString = ''
	SET @CommaCheck = right(@String,1) 
  
	SET @String = @String + @Delimitador
  
	--Busca la posición del primer delimitador
	SET @Pos = charindex(@Delimitador,@String)
	SET @NextPos = 1
  
	--Itera mientras exista un delimitador en el string
	WHILE (@pos <> 0)  
	BEGIN
		SET @NextString = substring(@String,1,@Pos - 1)
  
		INSERT INTO @ValueTable ([id], [valor]) Values (@nFila, @NextString)
  
		SET @String = substring(@String,@pos +1,len(@String))
   
		SET @nFila= @nFila+1
		SET @NextPos = @Pos
		SET @pos  = charindex(@Delimitador,@String)
	END
  
	RETURN
END


GO

/*CREACION DE PROCEDURE ALUMNOS*/
GO

CREATE PROCEDURE [dbo].[USP_MNT_Alumnos]
            
	@sOpcion VARCHAR(2) = '',   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @nIdAlumno  INT;
		DECLARE @sCodAlu	  VARCHAR(MAX);
		DECLARE @sNombres		VARCHAR(MAX);		
		DECLARE @sApellidos	VARCHAR(MAX);
		DECLARE @nEdad  INT;

		
		DECLARE @Correlativo INT;
				
	END
	
	--VARIABLE TABLA
	BEGIN

		DECLARE @tParametro TABLE (
			id int,
			valor varchar(max)
		);

	END

	--Descontena el parametro con split
	BEGIN
		IF(LEN(LTRIM(RTRIM(@pParametro))) > 0)
			BEGIN
			    INSERT INTO @tParametro (id, valor ) SELECT id, valor FROM dbo.Split(@pParametro, '|');
			END;
	END;
        
		
	IF @sOpcion = '01'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
			
			SELECT
				*
			FROM Alumnos
			                                                                                 
	END;                         

  ELSE IF @sOpcion = '02'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
    BEGIN
      SET @nIdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
    END

    BEGIN
      SELECT
        nIdAlumno,
		TRIM(sCodAlu) AS 'sCodAlu',
        sNombres,
        sApellidos,
		nEdad
      FROM Alumnos
      WHERE nIdAlumno = @nIdAlumno
    END
						                                                                                 
	END;

	ELSE IF @sOpcion = '03'  --INSERT
		BEGIN
			BEGIN
				SET @sNombres		= (SELECT valor FROM @tParametro WHERE id = 1);
				SET @sApellidos	= (SELECT valor FROM @tParametro WHERE id = 2);
				SET @nEdad		= (SELECT valor FROM @tParametro WHERE id = 3);
				
				SELECT @Correlativo = ISNULL(MAX(nIdAlumno), 0) + 1 FROM [Alumnos];

		  END	
      
		  BEGIN
    	
				  SELECT @sCodAlu = 'ALU'+right('0000' + convert(varchar(5), @Correlativo), 5)
					
				  INSERT INTO Alumnos
						  (sCodAlu,  sNombres,  sApellidos, nEdad)
				  VALUES	(@sCodAlu, @sNombres, @sApellidos, @nEdad)

				  SELECT CONCAT('1|',@sCodAlu)
		  		
		  END
		
	  END
	   
	   
	ELSE IF @sOpcion = '04'  -- ACTUALIZAR
	  BEGIN
      BEGIN
			  
			  SET @sNombres		= (SELECT valor FROM @tParametro WHERE id = 1);
        SET @sApellidos	= (SELECT valor FROM @tParametro WHERE id = 2);
        SET @nEdad	= (SELECT valor FROM @tParametro WHERE id = 3);

        SET @nIdAlumno	= (SELECT valor FROM @tParametro WHERE id = 4);

        SELECT @sCodAlu = sCodAlu FROM Alumnos WHERE nIdAlumno = @nIdAlumno
		  END	
		
			  BEGIN
			    UPDATE [Alumnos]                           
				  SET 
					  sNombres = @sNombres,
            sApellidos = @sApellidos,
			nEdad = @nEdad
				  WHERE 
					  nIdAlumno = @nIdAlumno

				  SELECT CONCAT('1|El Alumno con código ',@sCodAlu,' se registró con éxito')
			  END
	
        
	  END;

  ELSE IF @sOpcion = '05'  -- ELIMINAR
	  BEGIN
      BEGIN
			  SET @nIdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);

        SELECT @sCodAlu = sCodAlu FROM Alumnos WHERE nIdAlumno = @nIdAlumno
		  END	
		
			  BEGIN

          DELETE FROM [Alu_Cur] WHERE nIdAlumno = @nIdAlumno
                  
			    DELETE FROM [Alumnos] WHERE nIdAlumno = @nIdAlumno
          
				  SELECT CONCAT('1|El Alumno con código ',@sCodAlu,' ha Sido Eliminado')
			  END
	
        
	  END;
	
END

GO

/*CREACION DE PROCEDURE CURSOS*/
GO

CREATE PROCEDURE [dbo].[USP_MNT_Cursos]          
            
	@sOpcion VARCHAR(2) = '',   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @nIdCurso	INT;
		DECLARE @sCodCur	VARCHAR(MAX);
		DECLARE @sNomCur	VARCHAR(MAX);		
		DECLARE @nCreditos	VARCHAR(MAX);
		
		DECLARE @Correlativo INT;
				
	END
	
	--VARIABLE TABLA
	BEGIN

		DECLARE @tParametro TABLE (
			id int,
			valor varchar(max)
		);

	END

	--Descontena el parametro con split
	BEGIN
		IF(LEN(LTRIM(RTRIM(@pParametro))) > 0)
			BEGIN
			    INSERT INTO @tParametro (id, valor ) SELECT id, valor FROM dbo.Split(@pParametro, '|');
			END;
	END;
        		
	IF @sOpcion = '01'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
			
			SELECT
				*
			FROM Cursos
			                                                                                 
	END;                         

  ELSE IF @sOpcion = '02'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
    BEGIN
      SET @nIdCurso	= (SELECT valor FROM @tParametro WHERE id = 1);
    END

    BEGIN
		SELECT
		  nIdCurso,
			TRIM(sCodCur) AS 'sCodCur',
      sNomCur,
      nCreditos
		FROM Cursos
		WHERE
      nIdCurso = @nIdCurso
    END
						                                                                                 
	END;

	ELSE IF @sOpcion = '03'  --INSERT
	BEGIN
		  BEGIN
			SET @sNomCur		= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @nCreditos  = (SELECT valor FROM @tParametro WHERE id = 2);
						
			  SELECT @Correlativo = ISNULL(MAX(nIdCurso), 0) + 1 FROM [Cursos];

		  END	

		  BEGIN
    	
				  SELECT @sCodCur = 'CUR'+right('000' + convert(varchar(3), @Correlativo), 3)
					
				  INSERT INTO Cursos
						  (sCodCur, sNomCur,  nCreditos)
				  VALUES	(@sCodCur, @sNomCur, @nCreditos)

				  SELECT CONCAT('1|',@sCodCur)
		  		
		  END
		
	  END
	   	   
	ELSE IF @sOpcion = '04'  -- ACTUALIZAR
	BEGIN
      BEGIN
			  
			  SET @sNomCur		= (SELECT valor FROM @tParametro WHERE id = 1);
        SET @nCreditos	= (SELECT valor FROM @tParametro WHERE id = 2);
		SET @nIdCurso	= (SELECT valor FROM @tParametro WHERE id = 3);

        SELECT @sCodCur = sNomCur FROM Cursos WHERE nIdCurso = @nIdCurso

		  END	
		
			  BEGIN
			    UPDATE [Cursos]                           
				  SET 
					  sNomCur = @sNomCur,
            nCreditos = @nCreditos
				  WHERE 
					  nIdCurso = @nIdCurso

				  SELECT CONCAT('1|El Curso con código ',@sCodCur,' se registró con éxito')
			  END
	
        
	  END;

  ELSE IF @sOpcion = '05'  -- ELIMINAR
	BEGIN
      BEGIN
			  SET @nIdCurso	= (SELECT valor FROM @tParametro WHERE id = 1);

        SELECT @sCodCur = sCodCur FROM Cursos WHERE nIdCurso = @nIdCurso
		  END	
		
			  BEGIN

          DELETE FROM [Alu_Cur] WHERE nIdCurso = @nIdCurso
                  
			    DELETE FROM [Cursos] WHERE nIdCurso = @nIdCurso
          
				  SELECT CONCAT('1|El Curso con código ',@sCodCur,' ha Sido Eliminado')
			  END
	
        
	  END;
	
END

GO

/*CREACION DE PROCEDURE ALUMNOS X CURSO(NOTAS)*/
GO

CREATE PROCEDURE [dbo].[USP_MNT_AlumnosxCurso]          
            
	@sOpcion VARCHAR(2) = '',   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @nIdAluCur	INT;
		DECLARE @nIdAlumno	INT;
		DECLARE @nIdCurso	INT;
		DECLARE @nNota		INT;
		DECLARE @sCodAlu	VARCHAR(MAX);		
		DECLARE @sNomAlu	VARCHAR(MAX);		
		DECLARE @sNomCur	VARCHAR(MAX);		
    		
				
	END
	
	--VARIABLE TABLA
	BEGIN

		DECLARE @tParametro TABLE (
			id int,
			valor varchar(max)
		);

	END

	--Descontena el parametro con split
	BEGIN
		IF(LEN(LTRIM(RTRIM(@pParametro))) > 0)
			BEGIN
			    INSERT INTO @tParametro (id, valor ) SELECT id, valor FROM dbo.Split(@pParametro, '|');
			END;
	END;
        		
	IF @sOpcion = '01'   --CONSULTAR TODO
	BEGIN
		BEGIN
			SET @sCodAlu	= (SELECT valor FROM @tParametro WHERE id = 1);
		END
		
		SELECT
			nIdAluCur
			,Alu.nIdAlumno
			,sCodAlu
			,Cur.nIdCurso
			,sCodCur
      ,sNomCur
			,sNombres
			,sApellidos
			,nNota
			,nCreditos
		FROM Alu_Cur AluCur
		INNER JOIN Alumnos AS Alu ON AluCur.nIdAlumno = Alu.nIdAlumno
		INNER JOIN Cursos AS Cur ON AluCur.nIdCurso = Cur.nIdCurso
		WHERE
			sCodAlu = @sCodAlu

			                                                                                 
	END;                         

	ELSE IF @sOpcion = '02'   --CONSULTAR UNO
	BEGIN
    BEGIN
		SET @nIdAluCur	= (SELECT valor FROM @tParametro WHERE id = 1);
    END

    BEGIN
		SELECT
			nIdAluCur
			,Alu.nIdAlumno
			,sCodAlu
			,Cur.nIdCurso
			,sCodCur
      ,sNomCur
			,sNombres
			,sApellidos
			,nNota
			,nCreditos
		FROM Alu_Cur AluCur
		INNER JOIN Alumnos AS Alu ON AluCur.nIdAlumno = Alu.nIdAlumno
		INNER JOIN Cursos AS Cur ON AluCur.nIdCurso = Cur.nIdCurso
		WHERE
			nIdAluCur = @nIdAluCur
    END
						                                                                                 
	END;

	ELSE IF @sOpcion = '03'  --INSERT
	BEGIN
		  BEGIN
			SET @nIdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @nIdCurso	= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @nNota  = (SELECT valor FROM @tParametro WHERE id = 3);
			
			SELECT @sNomAlu = sNombres + ' ' + sApellidos FROM Alumnos WHERE nIdAlumno = @nIdAlumno
			SELECT @sNomCur = sNomCur FROM Cursos WHERE nIdCurso = @nIdCurso

		  END	

		  BEGIN
    			IF((SELECT COUNT(*) FROM Alu_Cur WHERE nIdAlumno = @nIdAlumno AND nIdCurso = @nIdCurso)=0)
					BEGIN
						INSERT INTO Alu_Cur
								(nIdAlumno, nIdCurso ,  nNota)
						VALUES	(@nIdAlumno, @nIdCurso ,  @nNota)

						SELECT CONCAT('1|','Sé Agregó la nota de ', @nNota,' al alumno ',@sNomAlu, ' en el curso ', @sNomCur)
		  		
					END

				ELSE
					BEGIN

						SELECT CONCAT('0|','El Alumno ', @sNomAlu,' ya tiene una nota registrada en el curso ', @sNomCur)
						
					END
				  
		  END
		
	  END
	   	   
	ELSE IF @sOpcion = '04'  -- ACTUALIZAR
	BEGIN
      BEGIN			
			SET @nNota		= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @nIdAluCur = (SELECT valor FROM @tParametro WHERE id = 1);

		  END	
		
			  BEGIN
			    UPDATE [Alu_Cur]                           
				  SET 
					  nNota = @nNota        
				  WHERE 
					  nIdAluCur = @nIdAluCur

				  SELECT '1|Se modificó la nota con éxito'
			  END
	
        
	  END;

  ELSE IF @sOpcion = '05'  -- ELIMINAR
	BEGIN
		BEGIN
			SET @nIdAluCur	= (SELECT valor FROM @tParametro WHERE id = 1);
		END	
		
		BEGIN

			DELETE FROM [Alu_Cur] WHERE nIdCurso = @nIdAluCur
            
			SELECT '1|Se eliminó la nota con éxito'
		END
	
        
	  END;
	
END
GO