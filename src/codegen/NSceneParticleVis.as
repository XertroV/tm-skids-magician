/// ! This file is generated from ../../../codegen/Scene/NSceneParticleVis.xtoml !
/// ! Do not edit this file manually !

// // const uint16 SZ_NSceneParticleVis_SMgr = 0x2E0;
class D_NSceneParticleVis_SMgr : RawBufferElem {
	D_NSceneParticleVis_SMgr(RawBufferElem@ el) {
		if (el.ElSize != 0x2E0) throw("invalid size for D_NSceneParticleVis_SMgr");
		super(el.Ptr, el.ElSize);
	}
	D_NSceneParticleVis_SMgr(uint64 ptr) {
		super(ptr, 0x2E0);
	}

	// GameScene = ISceneVis, 0x0, G
	uint64 get_GameScene() { return (this.GetUint64(0)); }
	CHmsZone@ get_Zone() { return cast<CHmsZone>(this.GetNod(0x8)); }
	NSceneSound_SMgr@ get_SoundMgr() { return cast<NSceneSound_SMgr>(this.GetNod(0x10)); }
	uint64 get_Unk1() { return (this.GetUint64(0x18)); }
	CHmsMgrVisDynaDecal2d@ get_mgrVisDynaDecal2d() { return cast<CHmsMgrVisDynaDecal2d>(this.GetNod(0x20)); }
	// has some refrences to Clouds_v.hlsli and common shaders
	uint64 get_Unk2() { return (this.GetUint64(0x28)); }
	CHmsMgrVisDyna@ get_mgrVisDyna() { return cast<CHmsMgrVisDyna>(this.GetNod(0x30)); }
	uint32 get_timer() { return (this.GetUint32(0x3C)); }
	// EmitterStructs are sorted backwards
	// Buffer: EmitterStructs = X, 0x40, 0x160, true
	// pointer to first element of EmitterStructs? (earliest pointer in memory of above, which are backwards)
	uint64 get_Unk3() { return (this.GetUint64(0x50)); }
	NSceneParticleVis_ActiveEmitters@ get_ActiveEmitters() { return NSceneParticleVis_ActiveEmitters(this.GetBuffer(0x118, 0xE8, true)); }
}

class NSceneParticleVis_ActiveEmitters : RawBuffer {
	NSceneParticleVis_ActiveEmitters(RawBuffer@ buf) {
		super(buf.Ptr, buf.ElSize, buf.StructBehindPtr);
	}
	NSceneParticleVis_ActiveEmitter@ GetActiveEmitter(uint i) {
		return NSceneParticleVis_ActiveEmitter(this[i]);
	}
}

// // const uint16 SZ_NSceneParticleVis_ActiveEmitter = 0xE8;
class NSceneParticleVis_ActiveEmitter : RawBufferElem {
	NSceneParticleVis_ActiveEmitter(RawBufferElem@ el) {
		if (el.ElSize != 0xE8) throw("invalid size for NSceneParticleVis_ActiveEmitter");
		super(el.Ptr, el.ElSize);
	}
	NSceneParticleVis_ActiveEmitter(uint64 ptr) {
		super(ptr, 0xE8);
	}

	CPlugParticleEmitterSubModel@ get_EmitterSubModel() { return cast<CPlugParticleEmitterSubModel>(this.GetNod(0x0)); }
	uint32 get_emitterType() { return (this.GetUint32(0x8)); }
	void set_emitterType(uint32 value) { this.SetUint32(0x8, value); }
	// only set when emitterType == 0 and == currIndex
	uint32 get_indexWhenType0() { return (this.GetUint32(0xC)); }
	void set_indexWhenType0(uint32 value) { this.SetUint32(0xC, value); }
	// use by all active emitters
	uint32 get_currIndex() { return (this.GetUint32(0x10)); }
	void set_currIndex(uint32 value) { this.SetUint32(0x10, value); }
	uint32 get_capacity() { return (this.GetUint32(0x14)); }
	void set_capacity(uint32 value) { this.SetUint32(0x14, value); }
	uint32 get_u1() { return (this.GetUint32(0x18)); }
	void set_u1(uint32 value) { this.SetUint32(0x18, value); }
	uint32 get_limit() { return (this.GetUint32(0x1C)); }
	void set_limit(uint32 value) { this.SetUint32(0x1C, value); }
	NSceneParticleVis_ActiveEmitter_PointsStruct@ get_PointsStruct() { return NSceneParticleVis_ActiveEmitter_PointsStruct(this.GetUint64(0x48)); }
	CPlugVisualIndexedTriangles@ get_Triangles1() { return cast<CPlugVisualIndexedTriangles>(this.GetNod(0x78)); }
	CPlugVisualIndexedTriangles@ get_Triangles2() { return cast<CPlugVisualIndexedTriangles>(this.GetNod(0x80)); }
	CPlugShaderApply@ get_Shader() { return cast<CPlugShaderApply>(this.GetNod(0x88)); }
	uint32 get_frameCountMaybe() { return (this.GetUint32(0x9C)); }
	void set_frameCountMaybe(uint32 value) { this.SetUint32(0x9C, value); }
	NSceneParticleVis_ActiveEmitter_AllWheels@ get_WheelsStruct() { return NSceneParticleVis_ActiveEmitter_AllWheels(this.GetUint64(0xB0)); }
}


class NSceneParticleVis_ActiveEmitter_PointsStruct : RawBufferElem {
	NSceneParticleVis_ActiveEmitter_PointsStruct(RawBufferElem@ el) {
		if (el.ElSize != 0x10) throw("invalid size for NSceneParticleVis_ActiveEmitter_PointsStruct");
		super(el.Ptr, el.ElSize);
	}
	NSceneParticleVis_ActiveEmitter_PointsStruct(uint64 ptr) {
		super(ptr, 0x10);
	}

	NSceneParticleVis_ActiveEmitter_Points@ get_SkidsPoints() { return NSceneParticleVis_ActiveEmitter_Points(this.GetBuffer(0x0, 0x58, false)); }
}

class NSceneParticleVis_ActiveEmitter_Points : RawBuffer {
	NSceneParticleVis_ActiveEmitter_Points(RawBuffer@ buf) {
		super(buf.Ptr, buf.ElSize, buf.StructBehindPtr);
	}
	NSceneParticleVis_ActiveEmitter_Point@ GetPoint(uint i) {
		return NSceneParticleVis_ActiveEmitter_Point(this[i]);
	}
}

class NSceneParticleVis_ActiveEmitter_Point : RawBufferElem {
	NSceneParticleVis_ActiveEmitter_Point(RawBufferElem@ el) {
		if (el.ElSize != 0x58) throw("invalid size for NSceneParticleVis_ActiveEmitter_Point");
		super(el.Ptr, el.ElSize);
	}
	NSceneParticleVis_ActiveEmitter_Point(uint64 ptr) {
		super(ptr, 0x58);
	}

	vec3 get_Pos() { return (this.GetVec3(0x0)); }
	void set_Pos(vec3 value) { this.SetVec3(0x0, value); }
	// crash on change
	uint get_NextIdMb() { return (this.GetUint32(0xC)); }
	// crash on change
	uint get_PrevIdMb() { return (this.GetUint32(0x10)); }
	uint16 InvisibleOffset = 0x14;
	bool get_Invisible() { return (this.GetBool(0x14)); }
	void set_Invisible(bool value) { this.SetBool(0x14, value); }
}


class NSceneParticleVis_ActiveEmitter_AllWheels : RawBufferElem {
	NSceneParticleVis_ActiveEmitter_AllWheels(RawBufferElem@ el) {
		if (el.ElSize != 0x10) throw("invalid size for NSceneParticleVis_ActiveEmitter_AllWheels");
		super(el.Ptr, el.ElSize);
	}
	NSceneParticleVis_ActiveEmitter_AllWheels(uint64 ptr) {
		super(ptr, 0x10);
	}

	NSceneParticleVis_ActiveEmitter_AllWheels_Wheels@ get_Wheels() { return NSceneParticleVis_ActiveEmitter_AllWheels_Wheels(this.GetBuffer(0x0, 0x48, true)); }
}

class NSceneParticleVis_ActiveEmitter_AllWheels_Wheels : RawBuffer {
	NSceneParticleVis_ActiveEmitter_AllWheels_Wheels(RawBuffer@ buf) {
		super(buf.Ptr, buf.ElSize, buf.StructBehindPtr);
	}
	NSceneParticleVis_ActiveEmitter_AllWheels_Wheel@ GetWheel(uint i) {
		return NSceneParticleVis_ActiveEmitter_AllWheels_Wheel(this[i]);
	}
}

class NSceneParticleVis_ActiveEmitter_AllWheels_Wheel : RawBufferElem {
	NSceneParticleVis_ActiveEmitter_AllWheels_Wheel(RawBufferElem@ el) {
		if (el.ElSize != 0x48) throw("invalid size for NSceneParticleVis_ActiveEmitter_AllWheels_Wheel");
		super(el.Ptr, el.ElSize);
	}
	NSceneParticleVis_ActiveEmitter_AllWheels_Wheel(uint64 ptr) {
		super(ptr, 0x48);
	}

	NSceneParticleVis_ActiveEmitter@ get_ActiveEmitter() { return NSceneParticleVis_ActiveEmitter(this.GetUint64(0x0)); }
}
