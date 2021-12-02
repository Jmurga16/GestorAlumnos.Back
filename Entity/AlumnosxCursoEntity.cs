using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class AlumnosxCursoEntity
    {
        public int nIdAluCur { get; set; }
        public int nIdAlumno { get; set; }
        public string sCodAlu { get; set; }
        public int nIdCurso { get; set; }
        public string sCodCur { get; set; }
        public string sNomCur { get; set; }
        public string sNombres { get; set; }
        public string sApellidos { get; set; }
        public int nNota { get; set; }
        public int nCreditos { get; set; }
    }
}
