using Entity;
using System;
using System.Data;
using System.Collections.Generic;
using Entity;
using NLog;

namespace Data
{
    public class AlumnosxCursoData
    {
        private readonly Logger logger = LogManager.GetCurrentClassLogger();
        #region Conexion
        private readonly Conexion oCon;

        public AlumnosxCursoData()
        {
            oCon = new Conexion(1);
        }
        #endregion

        private readonly List<AlumnosxCursoEntity> listaAlumno = new List<AlumnosxCursoEntity>();


        #region Alumnos
        public object DataAlumnosxCurso(GeneralEntity genEnt)
        {

            string msj = string.Empty;
            try
            {

                switch (genEnt.sOpcion)
                {

                    #region 01. Consultar Todo | 02. Consultar x Id
                    case "01":
                    case "02":

                        using (IDataReader dr = oCon.ejecutarDataReader("USP_MNT_AlumnosxCurso", genEnt.sOpcion, genEnt.pParametro))
                        {

                            while (dr.Read())
                            {
                                AlumnosxCursoEntity entity = new AlumnosxCursoEntity();


                                entity.nIdAluCur = Int32.Parse(Convert.ToString(dr["nIdAluCur"]));
                                entity.nIdAlumno = Int32.Parse(Convert.ToString(dr["nIdAlumno"]));
                                entity.sCodAlu = Convert.ToString(dr["sCodAlu"]);
                                entity.nIdCurso = Int32.Parse(Convert.ToString(dr["nIdCurso"]));
                                entity.sCodCur = Convert.ToString(dr["sCodCur"]);
                                entity.sNomCur = Convert.ToString(dr["sNomCur"]);
                                entity.nNota = Int32.Parse(Convert.ToString(dr["nNota"]));
                                entity.sNombres = Convert.ToString(dr["sNombres"]);
                                entity.sApellidos = Convert.ToString(dr["sApellidos"]);
                                entity.nCreditos = Int32.Parse(Convert.ToString(dr["nCreditos"]));

                                listaAlumno.Add(entity);

                            }

                            return listaAlumno;

                        }
                    #endregion

                    #region 03. Insertar | 04. Editar | 05. Eliminar
                    case "03":
                    case "04":
                    case "05":

                        string sResultado = Convert.ToString(oCon.EjecutarEscalar("USP_MNT_AlumnosxCurso", genEnt.sOpcion, genEnt.pParametro));
                        msj = sResultado;

                        return msj;
                    #endregion

                    default:
                        return null;
                }
            }
            catch (Exception exc4)
            {
                logger.Error(exc4);
                throw;
            }

        }
        #endregion
    }

}
