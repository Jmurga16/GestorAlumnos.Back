using Entity;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data
{
    public class CursoData
    {
        private readonly Logger logger = LogManager.GetCurrentClassLogger();
        #region Conexion
        private readonly Conexion oCon;

        public CursoData()
        {
            oCon = new Conexion(1);
        }
        #endregion

        private readonly List<CursoEntity> listaCurso = new List<CursoEntity>();


        #region Cursos
        public object DataCurso(GeneralEntity genEnt)
        {

            string msj = string.Empty;
            try
            {

                switch (genEnt.sOpcion)
                {

                    #region 01. Consultar Todo | 02. Consultar x Id
                    case "01":
                    case "02":

                        using (IDataReader dr = oCon.ejecutarDataReader("USP_MNT_Cursos", genEnt.sOpcion, genEnt.pParametro))
                        {

                            while (dr.Read())
                            {
                                CursoEntity entity = new CursoEntity();

                                entity.nIdCurso = Int32.Parse(Convert.ToString(dr["nIdCurso"]));
                                entity.sCodCur = Convert.ToString(dr["sCodCur"]);
                                entity.sNomCur = Convert.ToString(dr["sNomCur"]);
                                entity.nCreditos = Int32.Parse(Convert.ToString(dr["nCreditos"]));

                                listaCurso.Add(entity);

                            }

                            return listaCurso;

                        }
                    #endregion

                    #region 03. Insertar | 04. Editar | 05. Eliminar
                    case "03":
                    case "04":
                    case "05":

                        string sResultado = Convert.ToString(oCon.EjecutarEscalar("USP_MNT_Cursos", genEnt.sOpcion, genEnt.pParametro));
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
