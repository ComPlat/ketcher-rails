/****************************************************************************
 * Copyright (C) 2009-2010 GGA Software Services LLC
 *
 * This file may be distributed and/or modified under the terms of the
 * GNU Affero General Public License version 3 as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file.
 *
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 ***************************************************************************/

if (!window.chem || !chem.Struct)
	throw new Error("Include MolData.js first");

chem.Struct.prototype.calcConn = function (atom) {
	let conn = 0;
	for (let i = 0; i < atom.neighbors.length; ++i) {
		const hb = this.halfBonds.get(atom.neighbors[i]);
		const bond = this.bonds.get(hb.bid);

		switch (bond.type) {
			case chem.Struct.BOND.TYPE.SINGLE:
				conn += 1;
				break;
			case chem.Struct.BOND.TYPE.DOUBLE:
				conn += 2;
				break;
			case chem.Struct.BOND.TYPE.TRIPLE:
				conn += 3;
				break;
			case chem.Struct.BOND.TYPE.AROMATIC:
				if (atom.neighbors.length === 1) return [-1, true];
				return [atom.neighbors.length, true];
			default:
				return [-1, false];
		}
	}
	return [conn, false];
};

chem.Struct.Atom.isHeteroAtom = function (label) {
	return label !== 'C' && label !== 'H';
}

chem.Struct.Atom.prototype.calcValence = function (connectionCount) {
	var atom = this;
	var charge = atom.charge;
	var label = atom.label;
	if (atom.isQuery()) {
		this.implicitH = 0;
		return true;
	}
	var element = chem.Element.getElementByLabel(label);

	if (element == null) {
		this.implicitH = 0;
		return true;
	}

	var groupno = chem.Element.elements.get(element).group;
	var radicalCount = chem.Struct.radicalElectrons(atom.radical);

	var valence = connectionCount;
	var hydrogenCount = 0;
	var absCharge = Math.abs(charge);

	if (groupno == 1) {
		if (label == 'H' ||
			label == 'Li' || label == 'Na' || label == 'K' ||
			label == 'Rb' || label == 'Cs' || label == 'Fr') {
			valence = 1;
			hydrogenCount = 1 - radicalCount - connectionCount - absCharge;
		}
	} else if (groupno === 2) {
		if (
			connectionCount + radicalCount + absCharge === 2 ||
			connectionCount + radicalCount + absCharge === 0
		) {
			valence = 2;
		} else hydrogenCount = -1;
	} else if (groupno === 3) {
		if (label === 'B' || label === 'Al' || label === 'Ga' || label === 'In') {
			if (charge === -1) {
				valence = 4;
				hydrogenCount = 4 - radicalCount - connectionCount;
			} else {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount - absCharge;
			}
		} else if (label === 'Tl') {
			if (charge === -1) {
				if (radicalCount + connectionCount <= 2) {
					valence = 2;
					hydrogenCount = 2 - radicalCount - connectionCount;
				} else {
					valence = 4;
					hydrogenCount = 4 - radicalCount - connectionCount;
				}
			} else if (charge === -2) {
				if (radicalCount + connectionCount <= 3) {
					valence = 3;
					hydrogenCount = 3 - radicalCount - connectionCount;
				} else {
					valence = 5;
					hydrogenCount = 5 - radicalCount - connectionCount;
				}
			} else if (radicalCount + connectionCount + absCharge <= 1) {
				valence = 1;
				hydrogenCount = 1 - radicalCount - connectionCount - absCharge;
			} else {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount - absCharge;
			}
		}
	} else if (groupno === 4) {
		if (label === 'C' || label === 'Si' || label === 'Ge') {
			valence = 4;
			hydrogenCount = 4 - radicalCount - connectionCount - absCharge;
		} else if (label === 'Sn' || label === 'Pb') {
			if (connectionCount + radicalCount + absCharge <= 2) {
				valence = 2;
				hydrogenCount = 2 - radicalCount - connectionCount - absCharge;
			} else {
				valence = 4;
				hydrogenCount = 4 - radicalCount - connectionCount - absCharge;
			}
		}
	} else if (groupno === 5) {
		if (label === 'N' || label === 'P') {
			if (charge === 1) {
				valence = 4;
				hydrogenCount = 4 - radicalCount - connectionCount;
			} else if (charge === 2) {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount;
			} else if (
				label === 'N' ||
				radicalCount + connectionCount + absCharge <= 3
			) {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount - absCharge;
			} else {
				// ELEM_P && rad + conn + absCharge > 3
				valence = 5;
				hydrogenCount = 5 - radicalCount - connectionCount - absCharge;
			}
		} else if (label === 'Bi' || label === 'Sb' || label === 'As') {
			if (charge === 1) {
				if (radicalCount + connectionCount <= 2 && label !== 'As') {
					valence = 2;
					hydrogenCount = 2 - radicalCount - connectionCount;
				} else {
					valence = 4;
					hydrogenCount = 4 - radicalCount - connectionCount;
				}
			} else if (charge === 2) {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount;
			} else if (radicalCount + connectionCount <= 3) {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount - absCharge;
			} else {
				valence = 5;
				hydrogenCount = 5 - radicalCount - connectionCount - absCharge;
			}
		}
	} else if (groupno === 6) {
		if (label === 'O') {
			if (charge >= 1) {
				valence = 3;
				hydrogenCount = 3 - radicalCount - connectionCount;
			} else {
				valence = 2;
				hydrogenCount = 2 - radicalCount - connectionCount - absCharge;
			}
		} else if (label === 'S' || label === 'Se' || label === 'Po') {
			if (charge === 1) {
				if (connectionCount <= 3) {
					valence = 3;
					hydrogenCount = 3 - radicalCount - connectionCount;
				} else {
					valence = 5;
					hydrogenCount = 5 - radicalCount - connectionCount;
				}
			} else if (connectionCount + radicalCount + absCharge <= 2) {
				valence = 2;
				hydrogenCount = 2 - radicalCount - connectionCount - absCharge;
			} else if (connectionCount + radicalCount + absCharge <= 4) {
				// See examples in PubChem
				// [S] : CID 16684216
				// [Se]: CID 5242252
				// [Po]: no example, just following ISIS/Draw logic here
				valence = 4;
				hydrogenCount = 4 - radicalCount - connectionCount - absCharge;
			} else {
				// See examples in PubChem
				// [S] : CID 46937044
				// [Se]: CID 59786
				// [Po]: no example, just following ISIS/Draw logic here
				valence = 6;
				hydrogenCount = 6 - radicalCount - connectionCount - absCharge;
			}
		} else if (label === 'Te') {
			if (charge === -1) {
				if (connectionCount <= 2) {
					valence = 2;
					hydrogenCount = 2 - radicalCount - connectionCount - absCharge;
				}
			} else if (charge === 0 || charge === 2) {
				if (connectionCount <= 2) {
					valence = 2;
					hydrogenCount = 2 - radicalCount - connectionCount - absCharge;
				} else if (connectionCount <= 4) {
					valence = 4;
					hydrogenCount = 4 - radicalCount - connectionCount - absCharge;
				} else if (charge === 0 && connectionCount <= 6) {
					valence = 6;
					hydrogenCount = 6 - radicalCount - connectionCount - absCharge;
				} else {
					hydrogenCount = -1;
				}
			}
		}
	} else if (groupno === 7) {
		if (label === 'F') {
			valence = 1;
			hydrogenCount = 1 - radicalCount - connectionCount - absCharge;
		} else if (
			label === 'Cl' ||
			label === 'Br' ||
			label === 'I' ||
			label === 'At'
		) {
			if (charge === 1) {
				if (connectionCount <= 2) {
					valence = 2;
					hydrogenCount = 2 - radicalCount - connectionCount;
				} else if (
					connectionCount === 3 ||
					connectionCount === 5 ||
					connectionCount >= 7
				) {
					hydrogenCount = -1;
				}
			} else if (charge === 0) {
				if (connectionCount <= 1) {
					valence = 1;
					hydrogenCount = 1 - radicalCount - connectionCount;
					// While the halogens can have valence 3, they can not have
					// hydrogens in that case.
				} else if (
					connectionCount === 2 ||
					connectionCount === 4 ||
					connectionCount === 6
				) {
					if (radicalCount === 1) {
						valence = connectionCount;
						hydrogenCount = 0;
					} else {
						hydrogenCount = -1; // will throw an error in the end
					}
				} else if (connectionCount > 7) {
					hydrogenCount = -1; // will throw an error in the end
				}
			}
		}
	} else if (groupno === 8) {
		if (connectionCount + radicalCount + absCharge === 0) valence = 1;
		else hydrogenCount = -1;
	}
	if (chem.Struct.Atom.isHeteroAtom(label) && this.implicitHCount !== null) {
		hydrogenCount = this.implicitHCount;
	}
	this.valence = valence;
	this.implicitH = hydrogenCount;
	if (this.implicitH < 0) {
		this.valence = connectionCount;
		this.implicitH = 0;
		this.badConn = true;
		return false;
	}
	return true;
}

chem.Struct.Atom.prototype.calcValenceMinusHyd = function (conn) {
	const charge = this.charge || 0;
	const label = this.label;
	const element = chem.Element.getElementByLabel(this.label);
	if (!element) {
		// query atom, skip
		this.implicitH = 0;
		return 0;
	}

	const groupno = chem.Element.elements.get(elem).group;
	const rad = chem.Struct.radicalElectrons(this.radical);

	if (groupno === 3) {
		if (label === 'B' || label === 'Al' || label === 'Ga' || label === 'In') {
			if (charge === -1) {
				if (rad + conn <= 4) return rad + conn;
			}
		}
	} else if (groupno === 5) {
		if (label === 'N' || label === 'P') {
			if (charge === 1) return rad + conn;
			if (charge === 2) return rad + conn;
		} else if (label === 'Sb' || label === 'Bi' || label === 'As') {
			if (charge === 1) return rad + conn;
			else if (charge === 2) return rad + conn;
		}
	} else if (groupno === 6) {
		if (label === 'O') {
			if (charge >= 1) return rad + conn;
		} else if (label === 'S' || label === 'Se' || label === 'Po') {
			if (charge === 1) return rad + conn;
		}
	} else if (groupno === 7) {
		if (label === 'Cl' || label === 'Br' || label === 'I' || label === 'At') {
			if (charge === 1) return rad + conn;
		}
	}

	return rad + conn + Math.abs(charge);
};

chem.Struct.prototype.calcImplicitHydrogen = function (aid) {
	const atom = this.atoms.get(aid);
	const charge = atom.charge || 0;
	const [conn, isAromatic] = this.calcConn(atom);
	let correctConn = conn;
	atom.badConn = false;

	if (isAromatic) {
		if (atom.label === 'C' && charge === 0) {
			if (conn === 3) {
				atom.implicitH = - chem.Struct.radicalElectrons(atom.radical);
				return;
			}
			if (conn === 2) {
				atom.implicitH = 1 - chem.Struct.radicalElectrons(atom.radical);
				return;
			}
		} else if (
			(atom.label === 'O' && charge === 0) ||
			(atom.label === 'N' && charge === 0 && conn === 3) ||
			(atom.label === 'N' && charge === 1 && conn === 3) ||
			(atom.label === 'S' && charge === 0 && conn === 3) ||
			!atom.implicitH
		) {
			atom.implicitH = 0;
			return;
		} else if (!atom.hasImplicitH) {
			correctConn++;
		}
	}

	if (correctConn < 0 || atom.isQuery() || atom.attachmentPoints) {
		atom.implicitH = 0;
		return;
	}

	if (atom.explicitValence >= 0) {
		const elem = chem.Element.getElementByLabel(atom.label);
		atom.implicitH = elem
			? atom.explicitValence - atom.calcValenceMinusHyd(correctConn)
			: 0;
		if (atom.implicitH < 0) {
			atom.implicitH = 0;
			atom.badConn = true;
		}
	} else {
		atom.calcValence(correctConn);
	}
};
