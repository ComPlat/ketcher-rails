if (!window.Prototype)
	throw new Error("Prototype.js should be loaded first");
if (!window.rnd)
	throw new Error("rnd should be defined prior to loading this file");

// IUPAC recommended atomic weights, for average molecular weight
rnd.elements = {
  "H":1.00794,
  "He":4.002602,
  "Li":6.941,
  "Be":9.012182,
  "B":10.811,
  "C":12.0107,
  "N":14.0067,
  "O":15.9994,
  "F":18.9984032,
  "Ne":20.1797,
  "Na":22.98977,
  "Mg":24.305,
  "Al":26.981538,
  "Si":28.0855,
  "P":30.973761,
  "S":32.065,
  "Cl":35.453,
  "Ar":39.948,
  "K":39.0983,
  "Ca":40.078,
  "Sc":44.95591,
  "Ti":47.867,
  "V":50.9415,
  "Cr":51.9961,
  "Mn":54.938049,
  "Fe":55.845,
  "Co":58.9332,
  "Ni":58.6934,
  "Cu":63.546,
  "Zn":65.38,
  "Ga":69.723,
  "Ge":72.64,
  "As":74.9216,
  "Se":78.96,
  "Br":79.904,
  "Kr":83.798,
  "Rb":85.4678,
  "Sr":87.62,
  "Y":88.90585,
  "Zr":91.224,
  "Nb":92.90638,
  "Mo":95.96,
  "Tc":98.0,
  "Ru":101.07,
  "Rh":102.9055,
  "Pd":106.42,
  "Ag":107.8682,
  "Cd":112.411,
  "In":114.818,
  "Sn":118.701,
  "Sb":121.76,
  "Te":127.6,
  "I":126.90447,
  "Xe":131.293,
  "Cs":132.90545,
  "Ba":137.327,
  "La":138.9055,
  "Ce":140.116,
  "Pr":140.90765,
  "Nd":144.24,
  "Pm":145.0,
  "Sm":150.36,
  "Eu":151.964,
  "Gd":157.25,
  "Tb":158.92534,
  "Dy":162.5,
  "Ho":164.93032,
  "Er":167.259,
  "Tm":168.93421,
  "Yb":173.054,
  "Lu":174.9668,
  "Hf":178.49,
  "Ta":180.9479,
  "W":183.84,
  "Re":186.207,
  "Os":190.23,
  "Ir":192.217,
  "Pt":195.078,
  "Au":196.96655,
  "Hg":200.59,
  "Tl":204.3833,
  "Pb":207.2,
  "Bi":208.9804,
  "Po":209.0,
  "At":210.0,
  "Rn":222.0,
  "Fr":223.0,
  "Ra":226.0,
  "Ac":227.0,
  "Th":232.0381,
  "Pa":231.03588,
  "U":238.02891,
  "Np":237.05,
  "Pu":244.06,
  "Am":243.06,
  "Cm":247.07,
  "Bk":247.07,
  "Cf":251.08,
  "Es":252.08,
  "Fm":257.1,
  "Md":258.1,
  "No":259.1,
  "Lr":262.11,
  "Rf":265.12,
  "Db":268.13,
  "Sg":271.13,
  "Bh":270.0,
  "Hs":277.15,
  "Mt":276.15,
  "Ds":281.16,
  "Rg":280.16,
  "Cn":285.17,
  "Uut":284.18,
  "Fl":289.19,
  "Uup":288.19,
  "Lv":293.0,
  "Uus":294.0,
  "Uuo":294.0,
	"R#": 0.0 // for residues
}

rnd.getAtomicWeight = function(atom) {
	var result = rnd.elements[atom.label];
	if(atom.implicitH > 0)
		result += rnd.elements['H'] * atom.implicitH;
	return result;
}

rnd.writeElement = function(atom_label, ela){
	var str = ''
	if (ela[atom_label]) {
		str += atom_label;

		if (ela[atom_label] > 1)
		  str += ela[atom_label]
	}

	return str;
}

rnd.writeELAItem = function(atom_label, atom_n, molecularWeight) {
	if(!atom_n > 0) return '';

	var value = rnd.elements[atom_label] * atom_n / molecularWeight * 100;// in %
	if(!value > 0) value = 0;
	return atom_label + ': ' + value.toFixed(2) + ' '
}

rnd.buildELA = function(ela, molecularWeight) {
	var result = '';
	result += rnd.writeELAItem('C', ela['C'], molecularWeight);
	result += rnd.writeELAItem('H', ela['H'], molecularWeight);
	Object.keys(ela).sort().forEach(function(key, index) {
		if(key == 'C' || key == 'H') return;

		result += rnd.writeELAItem(key, ela[key], molecularWeight)
	});
	return result;
}

rnd.buildFormula = function(ela){
	result = '';

	// write C and H atoms first
	result += rnd.writeElement('C', ela);
	result += rnd.writeElement('H', ela);
	var keys = Object.keys(ela).sort(); // after CH follow others in sorted order
	keys.forEach(function(key,index) {
		if (key == 'C' || key == 'H') {
			return;
		}
		result += rnd.writeElement(key, ela);
	});

	return result;
}

rnd.getMoleculeInfo = function() {
	var sum = 0;
	var ela = {
		"H": 0
	};
	ui.ctab.atoms.each(function (aid, atom)
	{
		if(ela[atom.label] == undefined) {
			ela[atom.label] = 1
		} else {
			ela[atom.label]++;
		}
		ela['H'] += atom.implicitH;

		sum += rnd.getAtomicWeight(atom);
	});

	var formula = rnd.buildFormula(ela);
	var ela_data = rnd.buildELA(ela, sum);

	return {
		"mw_total": sum,
		"formula": formula,
		"formatted_ela": ela_data
	};
};
